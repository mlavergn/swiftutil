import Foundation

public struct App {

	/**
	*/
	public static var bundleId: String {
		if let ident = Bundle.main.bundleIdentifier {
			return ident
		} else {
			return "com.example.NoBundle"
		}
	}

	/**
	*/
	public static var bundleVersion: String? {
		if let version = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String {
			return version as String
		} else {
			return "0.0.0"
		}
	}
}
