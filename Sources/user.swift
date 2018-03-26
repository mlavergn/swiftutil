/// User struct with user helpers
///
/// - author: Marc Lavergne <mlavergn@gmail.com>
/// - copyright: 2017 Marc Lavergne. All rights reserved.
/// - license: MIT

import Foundation

public struct User {

	/// The active username as a String
	public static var username: String {
		return NSUserName()
	}

	/// The active user full name as a String
	public static var fullName: String {
		return NSFullUserName()
	}

	/// Query user defaults for an Int value
	///
	/// - Parameter forKey: key name as a String
	/// - Returns: value as an Int
	public static func defaultsInteger(forKey: String) -> Int {
		return UserDefaults().integer(forKey: forKey)
	}

	/// Query user defaults for a String value
	///
	/// - Parameter forKey: key name as a String
	/// - Returns: value as an String
	public static func defaultsString(forKey: String) -> String? {
		return UserDefaults().string(forKey: forKey)
	}
}
