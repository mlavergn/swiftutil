/// App struct with package or bundle related helpers
///
/// - author: Marc Lavergne <mlavergn@gmail.com>
/// - copyright: 2017 Marc Lavergne. All rights reserved.
/// - license: MIT
import Foundation

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
}
