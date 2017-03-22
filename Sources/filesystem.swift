import Foundation

public struct FileSystem {

	/**
	*/
	public static var currentDirectory: URL {
		return URL(string:"file://" + FileManager.default.currentDirectoryPath)!
	}

	/**
	*/
	public static var temporaryDirectory: URL {
		if #available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *) {
			return FileManager.default.temporaryDirectory
		} else {
			// @TODO fix this
			return URL(string:"")!
		}
	}

	/**
	*/
	public static var documentDirectory: URL {
		let documentsPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
		if documentsPaths.count > 0 {
			return URL(string:"file://" + documentsPaths[0])!
		} else {
			// @TODO fix this
			return URL(string:"")!
		}
	}

	/**
	*/
	public static var homeDirectory: URL {
		if #available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *) {
			return FileManager.default.homeDirectoryForCurrentUser
		} else {
			// @TODO fix this
			return URL(string:"")!
		}
	}

	/**
	*/
	public static func exists(path: String) -> Bool {
		return FileManager.default.fileExists(atPath:path)
	}

	/**
	*/
	public static func create(path: String) {
		do {
			if !exists(path:path) {
				try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
			}
		} catch {
			// @TODO log an error
		}
	}
}
