import Foundation

public struct App {

	/**
	Application bundle identifier
	*/
	public static var bundleId: String {
		if let ident = Bundle.main.bundleIdentifier {
			return ident
		} else {
			return "com.example.NoBundle"
		}
	}

	/**
	Application bundle version
	*/
	public static var bundleVersion: String {
		if let version = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String {
			return version
		} else {
			return "0"
		}
	}
}
