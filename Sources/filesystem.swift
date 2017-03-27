/// Filesystem struct with file access helpers
///
/// - author: Marc Lavergne <mlavergn@gmail.com>
/// - copyright: 2017 Marc Lavergne. All rights reserved.
/// - license: MIT
import Foundation

// MARK: - FileSystem struct
public struct FileSystem {

	/// Current working directory as a URL
	public static var currentDirectory: URL {
		if let url = URL(string:"file://" + FileManager.default.currentDirectoryPath) {
			return url
		} else {
			/// -todo: change to return an error
			return rootDirectory
		}
	}

	/// Current temporary directory as a URL
	public static var temporaryDirectory: URL {
		if #available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *) {
			return FileManager.default.temporaryDirectory
		} else {
			/// -todo: change to return an error
			return rootDirectory
		}
	}

	/// Documents directory as a URL
	public static var documentDirectory: URL {
		let documentsPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
		if documentsPaths.count > 0 {
			return URL(string:"file://" + documentsPaths[0])!
		} else {
			/// -todo: change to return an error
			return rootDirectory
		}
	}

	/// Home directory as a URL
	public static var homeDirectory: URL {
		#if os(iOS)
			if let url = URL(string:NSHomeDirectory()) {
				return url
			} else {
				/// -todo: change to return an error
				return rootDirectory
			}
		#elseif os(macOS)
			if #available(macOS 10.12, *) {
				return FileManager.default.homeDirectoryForCurrentUser
			} else {
				/// -todo: change to return an error
				return rootDirectory
			}
		#else
			/// -todo: change to return an error
			return rootDirectory
		#endif
	}

	/// Root directory as a URL
	public static var rootDirectory: URL {
		return URL(string:"file:///")!
	}

	/// Verify the existance of the given path
	///
	/// - Parameter path: Full path as a String
	/// - Returns: Bool with true if path exists, otherwise false
	public static func exists(path: String) -> Bool {
		return FileManager.default.fileExists(atPath:path)
	}

	/// Creates the directory tree specified in full path, including intermediate directories
	///
	/// - Parameter path: Full path as a String
	public static func createDirectory(path: String) {
		do {
			if !exists(path:path) {
				try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
			}
		} catch {
			/// -todo: fix this
		}
	}
}
