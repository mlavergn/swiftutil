/// Persistence via NSUserDefaults
///
/// - author: Marc Lavergne <mlavergn@gmail.com>
/// - copyright: 2017 Marc Lavergne. All rights reserved.
/// - license: MIT
import Foundation

// This is essentially a set of helpers for persisting to UserDefaults
// This had additional functionality but it's not quite consumable
// so this is a little bit of a stub class
public struct PersistableObject {
    var lock = NSRecursiveLock()
    var persistanceKey = "PersistableObjectKey"

    init(_ key: String) {
        persistanceKey = key
    }

    // remove the persisted object
    func remove() {
        lock.lock()
        defer { lock.unlock() }

        UserDefaults.standard.removeObject(forKey: persistanceKey)
    }

    // retrieve the persisted object
    func get() -> Any? {
        lock.lock()
        defer { lock.unlock() }

        return UserDefaults.standard.object(forKey: persistanceKey)
    }

    // set the persisted object
    func set(_ object: Any) {
        lock.lock()
        defer { lock.unlock() }

        UserDefaults.standard.set(object, forKey: persistanceKey)
    }
}
