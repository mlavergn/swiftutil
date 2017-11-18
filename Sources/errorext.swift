/// NSError extension
///
/// - author: Marc Lavergne <mlavergn@gmail.com>
/// - copyright: 2017 Marc Lavergne. All rights reserved.
/// - license: MIT

import Foundation

/// Key set used to populate the error userInfo
///
/// - function: name of current function
/// - file: file containing the function
/// - line: line within the containing file
enum ErrorKey: String {
	case function = "error.function"
	case file     = "error.file"
	case line     = "error.line"
}

extension NSError {

	/// Constructor that can auto-generate an NSError
	///
	/// - Parameters:
	///   - message: descripton as a String (defaults to blank)
	///   - function: function name as a String (should not be provided)
	///   - file: file name as a String (should not be provided)
	///   - line: line as an Int (should not be provided)
	/// - Returns: NSError instance
	public static func error(_ message: String = "", function: String = #function, file: String = #file, line: Int = #line) -> NSError {
		let customError = NSError(domain: App.bundleId, code: 0, userInfo: [
				NSLocalizedDescriptionKey: message,
				ErrorKey.function.rawValue: function,
				ErrorKey.file.rawValue: file,
				ErrorKey.line.rawValue: line
			])

		return customError
	}
}
