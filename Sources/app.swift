/// App struct with package or bundle related helpers
///
/// - author: Marc Lavergne <mlavergn@gmail.com>
/// - copyright: 2017 Marc Lavergne. All rights reserved.
/// - license: MIT

import Foundation
#if os(iOS) || os(tvOS)
import UIKit
#endif

// MARK: - App struct
public struct App {

	/// Application bundle identifier
	public static var bundleId: String {
		if let ident = Bundle.main.bundleIdentifier {
			return ident
		} else {
			return "com.example.NoBundle"
		}
	}

	/// Application bundle version
	public static var bundleVersion: String {
		if let version = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String {
			return version
		} else {
			return "0"
		}
	}

	/// Set a key value pair in the application plist
	///
	/// - Parameters:
	///   - value: value as an Any
	///   - key: plist key as a String
	public static func setPlistKey(value: String, key: Any) {
		if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
			Log.debug(path)
			if let plist = NSMutableDictionary.init(contentsOfFile: path) {
				plist[key] = value
				plist.write(toFile: path, atomically: true)
			}
		}
	}

	/// Change the app icon to the named plist icon, use nil for default icon
	/// http://stackoverflow.com/questions/43097604/alternate-icon-in-ios-10-3
	/// You MUST ask the user prior to changing the icon
	private static func updateIcon(name: String?) {
		#if os(iOS) || os(tvOS)
		if #available(iOS 10.3, *) {
			if UIApplication.shared.supportsAlternateIcons {
				UIApplication.shared.setAlternateIconName(name) { (err: Error?) in
					if err != nil {
						Log.error(err!)
					}
				}
			}
		}
		#endif
	}

	/// Bool with true if the application running in a sandbox, otherwise false
	public static var isSandboxed: Bool {
		let dir = NSHomeDirectory()
		if let bundleName: String = Bundle.main.bundleIdentifier {
			if dir.contains("/containers/" + bundleName) {
				return true
			}
		}
		return false
	}

	/// Bool with true if the application running in a simulator, otherwise false
	public static var isSimulator: Bool {
		let cwdPath = FileManager.default.currentDirectoryPath
		if cwdPath.contains("/CoreSimulator/") {
			return true
		}
		return false
	}
}
