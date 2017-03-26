import Foundation

enum ErrorKey: String {
	case function = "error.function"
	case file     = "error.file"
	case line     = "error.line"
}

extension NSError {

	/**
	*/
	public static func error(_ message: String, function: String = #function, file: String = #file, line: Int = #line) -> NSError {
		let customError = NSError(domain: App.bundleId, code: 0, userInfo: [
				NSLocalizedDescriptionKey: message.localized,
				ErrorKey.function: function,
				ErrorKey.file: file,
				ErrorKey.line: line
			])

		return customError
	}
}
