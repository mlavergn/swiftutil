import Foundation

public struct User {

	/**
	*/
	public static var username: String {
		return NSUserName()
	}

	/**
	*/
	public static func defaultsInteger(forKey: String) -> Int {
		return UserDefaults().integer(forKey:forKey)
	}

	/**
	*/
	public static func defaultsString(forKey: String) -> String? {
		return UserDefaults().string(forKey:forKey)
	}
}
