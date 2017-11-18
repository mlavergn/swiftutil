/// Data extensions to provide common operations
///
/// - author: Marc Lavergne <mlavergn@gmail.com>
/// - copyright: 2017 Marc Lavergne. All rights reserved.
/// - license: MIT

import Foundation

// MARK: - Data extension
public extension Data {

	/// Appends a String to a mutable Data
	///
	/// - Parameter string: String to append
	mutating public func appendString(_ string: String) {
		if let data = string.data {
			self.append(data)
		}
	}

	/// Converts a Data to a UTF8 String if possible
	///
	/// - Returns: String if convertible, otherwise empty String
	public func string() -> String {
		guard let result = String.init(data: self) else {
			return ""
		}

		return result
	}
}
