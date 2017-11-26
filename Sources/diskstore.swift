// DiskStore maintains a data store on disk
//
// - author: Marc Lavergne <mlavergn@gmail.com>
// - copyright: 2017 Marc Lavergne. All rights reserved.
// - license: MIT

import Foundation

// MARK: - DiskStoreEntry

/// DiskStoreEntry keys
private enum DiskStoreEntryKeys: String {
    case id
    case created
    case values
}

///
/// DiskStoreEntry can be persisted via DiskStore
///
public class DiskStoreEntry: NSObject, NSCoding {
    let id: String
    let created: Date
	var values: [AnyHashable: Any]

	init(id: String? = nil, created: Date? = nil, values: [String: Any] = [:]) {
        self.id = id ?? NSUUID().uuidString
        self.created = created ?? Date()
        self.values = values
        super.init()
    }

    public required init(coder decoder: NSCoder) {
        self.id = decoder.decodeObject(forKey: DiskStoreEntryKeys.id.rawValue) as? String ?? NSUUID().uuidString
        self.created = decoder.decodeObject(forKey: DiskStoreEntryKeys.created.rawValue) as? Date ?? Date()
		self.values = decoder.decodeObject(forKey: DiskStoreEntryKeys.values.rawValue) as? [AnyHashable: Any] ?? [:]
    }

    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: DiskStoreEntryKeys.id.rawValue)
        coder.encode(created, forKey: DiskStoreEntryKeys.created.rawValue)
        coder.encode(values, forKey: DiskStoreEntryKeys.values.rawValue)
    }
}

// MARK: - DiskStore

/// DiskStore errors
enum DiskStoreError: Error {
    case failedToArchiveDataStore
    case failedToUnarchiveDataStore
    case failedToFindApplicationSupportPath
    case failedToReadApplicationSupportPath
    case failedToWriteApplicationSupportPath
}

/// DiskStore keys
private enum DiskStoreKeys: String {
    case dataset
    case timestamp
}

///
/// DiskStore persists DiskStoreEntries to disk while allowing for updates
///
public class DiskStore: NSObject, NSCoding {

    private var dataset: [String: DiskStoreEntry]
    private var memoryTimestamp: Date = Date.distantPast

    /// Name under the Application Support folder for dataset
    static private let storeFile = "com.example.Dataset.plist"
    let diskStoreNotification = Notification.Name(storeFile)

    /// Construct the data path, creating any required directories
    private static let storeDirectoryBaseURL: URL = {
        let paths = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
        var pathRoot: String
        if let pathApplicationSupport = paths.last {
            pathRoot = pathApplicationSupport
        } else {
            // we should never wind up barring a fundamental change in iOS
            pathRoot = ("~/Library/Application Support" as NSString).expandingTildeInPath
            Log.warn(DiskStoreError.failedToFindApplicationSupportPath)
        }
        var pathURL = URL(fileURLWithPath: pathRoot, isDirectory: true)
        // trying is quicker than checking in this case
        try? FileManager.default.createDirectory(at: pathURL, withIntermediateDirectories: true, attributes: nil)

        pathURL.appendPathComponent(storeFile)

        return pathURL
    }()

    // init is offered for convenience
    override convenience init() {
        let disk = DiskStore.read()
        self.init(dataset: disk.dataset)
        self.memoryTimestamp = disk.memoryTimestamp
    }

    // designated initializer
    private init(dataset: [String: DiskStoreEntry]) {
        self.dataset = dataset
        self.memoryTimestamp = DiskStore.diskTimestamp()
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(DiskStore.handleNotification), name: diskStoreNotification, object: nil)
    }

    // designated de-initializer
    deinit {
        NotificationCenter.default.removeObserver(self, name: diskStoreNotification, object: nil)
    }

    /// Describe the contents of the DiskStore
    override public var description: String {
        return "\(self.memoryTimestamp): \(self.dataset)"
    }

    // MARK: - NSCoding

    required public init(coder decoder: NSCoder) {
        if let dataset = decoder.decodeObject(forKey: DiskStoreKeys.dataset.rawValue) as? [String: DiskStoreEntry] {
            self.dataset = dataset
            self.memoryTimestamp = DiskStore.diskTimestamp()
        } else {
            self.dataset = [:]
            self.memoryTimestamp = Date.distantPast
        }
    }

    public func encode(with coder: NSCoder) {
        coder.encode(self.dataset, forKey: DiskStoreKeys.dataset.rawValue)
    }

    // MARK: - Synchronization

     @objc func handleNotification(withNotification notification: NSNotification) {
         let newCheckpoint = notification.userInfo?[DiskStoreKeys.timestamp.rawValue] as? Date ?? DiskStore.diskTimestamp()
         if self.memoryTimestamp != newCheckpoint {
             sync()
         }
     }

    /// Sync the in-memory contents from the disk truth
    private func sync() {
        if self.memoryTimestamp < DiskStore.diskTimestamp() {
            let latest = DiskStore.read()
            self.dataset = latest.dataset
            self.memoryTimestamp = latest.memoryTimestamp
        }
    }

    /// Commits the in-memory contents to the disk and notifies any copies
    ///
    /// - Returns: true if successfully persisted, otherwise false
    private func commit() -> Bool {
        // are we missing an update
        if self.memoryTimestamp < DiskStore.diskTimestamp() {
            sync()
            return false
        }

        // we're good, write
        let result = DiskStore.write(self)
        if result {
            self.memoryTimestamp = DiskStore.diskTimestamp()
            NotificationCenter.default.post(name: diskStoreNotification, object: nil, userInfo: nil)
        }
        return result
    }

    // MARK: - Disk IO

    /// The last modified date of the persisted store
    ///
    /// - Returns: Date of the current persisted store last modification
    private static func diskTimestamp() -> Date {
        let resourceValues = try? DiskStore.storeDirectoryBaseURL.resourceValues(forKeys: [.contentModificationDateKey])
        guard let checkpoint = resourceValues?.contentModificationDate else {
            return Date.distantPast
        }
        return checkpoint
    }

    /// Reads the store from disk
    ///
    /// - Returns: DiskStore instance from disk
    private static func read() -> DiskStore {
        let reachable = (try? storeDirectoryBaseURL.checkResourceIsReachable()) ?? false
        if reachable {
            guard let dataset = NSKeyedUnarchiver.unarchiveObject(withFile: storeDirectoryBaseURL.path) as? DiskStore else {
                Log.error(DiskStoreError.failedToUnarchiveDataStore)
                /// we failed to read, potential corruption, delete any existing file
                try? FileManager.default.removeItem(at: storeDirectoryBaseURL)
                let store = DiskStore(dataset: [:])
                _ = write(store)
                store.memoryTimestamp = DiskStore.diskTimestamp()
                return store
            }

            dataset.memoryTimestamp = DiskStore.diskTimestamp()
            return dataset
        } else {
            Log.error(DiskStoreError.failedToReadApplicationSupportPath)
        }
        return DiskStore(dataset: [:])
    }

    /// Write the store to disk
    /// We take a persimistic view of the write. We write to a tmp file
    /// and await a success before synchronously moving the file into
    /// place
    ///
    /// - Parameter store: DataStore to persist to disk
    /// - Returns: true if write was successful, otherwise false
    @discardableResult
    private static func write(_ store: DiskStore) -> Bool {
        var pathURL = DiskStore.storeDirectoryBaseURL
        pathURL.appendPathExtension(".tmp")
        let result = NSKeyedArchiver.archiveRootObject(store, toFile: pathURL.path)
        if result {
            do {
                try _ = FileManager.default.replaceItemAt(DiskStore.storeDirectoryBaseURL, withItemAt: pathURL, options:[.usingNewMetadataOnly])
            } catch {
                Log.error(DiskStoreError.failedToWriteApplicationSupportPath)
                try? FileManager.default.removeItem(at: pathURL)
                return false
            }
        } else {
            Log.error(DiskStoreError.failedToArchiveDataStore)
            try? FileManager.default.removeItem(at: pathURL)
        }
        return result
    }

    // MARK: - Features

    /// Sets an entry in the store
    ///
    /// - Parameters:
    ///   - entry: DiskStoreEntry to set
    ///   - attempts: Maximum number of attempts to persist the change
    /// - Returns: true is successfully persisted, otherwise false
    @discardableResult
    func set(_ entry: DiskStoreEntry, _ attempts: Int = 3) -> Bool {
        self.dataset[entry.id] = entry

        if !commit() {
            if attempts == 0 {
                return false
            } else {
                return set(entry, attempts - 1)
            }
        }

        return true
    }

    /// Deletes the given entry from the store
    ///
    /// - Parameters:
    ///   - entry: DiskStoreEntry to remove
    ///   - attempts: Maximum number of attempts to persist the change
    /// - Returns: true is successfully persisted, otherwise false
    func remove(_ entry: DiskStoreEntry, _ attempts: Int = 3) -> Bool {
        self.dataset[entry.id] = nil

        if !commit() {
            if attempts == 0 {
                return false
            } else {
                return remove(entry, attempts - 1)
            }
        }

        return true
    }

    /// Returns the current snapshot of the disk store entry
    ///
    /// - Parameter entryId: UUID for the entry
    /// - Returns: DiskStoreEntry instance if found, otherwise nil
    func findForID(_ entryId: String) -> DiskStoreEntry? {
        return self.dataset[entryId]
    }
}
