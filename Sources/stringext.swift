/// String extensions to provide common operations
///
/// Swift diverged from Objective-C in how it represents strings internally.
/// Objective-C had a close correlary to C strings. Swift uses grapheme
/// clusters, abstracting the definition of character beyond byte counts.
/// This causes some added work when dealing with characters.
///
/// - author: Marc Lavergne <mlavergn@gmail.com>
/// - copyright: 2017 Marc Lavergne. All rights reserved.
/// - license: MIT
import Foundation

// MARK: - String extension
public extension String {

	/// Creates a string object from a UTF8 C string
	///
	/// - Parameter data: UTF8 C string
	public init?(validatingUTF8 cString: UnsafePointer<UInt8>) {
		guard let (s, _) = String.decodeCString(cString, as: UTF8.self, repairingInvalidCodeUnits: false) else {
			return nil
		}
		self = s
	}

	/// Creates a string object from a UTF8 Data representation
	///
	/// - Parameter data: UTF8 Data representation
	public init?(data: Data) {
		guard let (s) = String(data:data, encoding:.utf8) else {
			return nil
		}
		self = s
	}

	/// Localized String value
	/// - todo: implement
	public var localized: String {
		return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
	}

	/// Data UTF8 representation of String
	public var data: Data? {
		return self.data(using:.utf8)
	}

	/// Length of the String
	public var length: Int {
		return self.characters.count
	}

	/// Trims leading and trailing whitespace
	public var trim: String {
		return self.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
	}

	/// Extracts a substring from a given index
	///
	/// - Parameter from: character index as an Int marking the start of substring
	/// - Returns: substring as a String
	public func index(from: Int) -> Index {
		return self.index(startIndex, offsetBy:from)
	}

	/// Finds the character offset of a substring within a string
	///
	/// - Parameter substring: substring to search for as a String
	/// - Returns: character offset as an Int
	public func find(_ substring: String) -> Int {
		let range = self.range(of:substring)
		if range == nil {
			return -1
		} else {
			return self.distance(from:self.startIndex, to:range!.lowerBound)
		}
	}

	/// Extracts a substring given a set of from / to indexes
	///
	/// - Parameters:
	///   - from: character index as an Int marking the start of substring
	///   - to: characters index as an Int marking the end of substring
	/// - Returns: substring as a String
	public func substring(from: Int, to: Int) -> String {
		let start = self.index(self.startIndex, offsetBy:from)
		let end = self.index(self.startIndex, offsetBy:to)
		let range = start..<end

		return self.substring(with: range)
	}

	/// Extracts a substring from start to the given to offset
	///
	/// - Parameters:
	///   - from: characters index as an Int marking the start of substring,
	///						if a negative value, index is from the end of the string
	/// - Returns: substring as a String
	public func substring(from: Int) -> String {
		var range: Range<Index>?
		if from >= 0 {
			let start = self.index(self.startIndex, offsetBy:from)
			range = start..<self.endIndex
		} else {
			let start = self.index(self.endIndex, offsetBy:from)
			range = start..<self.endIndex
		}
		
		return self.substring(with: range!)
	}

	/// Extracts a substring from start to the given to offset
	///
	/// - Parameters:
	///   - to: characters index as an Int marking the end of substring
	/// - Returns: substring as a String
	public func substring(to: Int) -> String {
		return self.substring(from: 0, to: to)
	}

	/// Extracts the character at the given index
	///
	/// - Parameter index: index of character as Int
	/// - Returns: Character
	public func characterAt(index: Int) -> Character {
		return self[self.index(self.startIndex, offsetBy:index)]
	}

	/// Treats the string as a path and isolates the filename
	public var fileName: String {
		return ((self as NSString).lastPathComponent as NSString).deletingPathExtension
	}

	/// Replaces a substring within a String
	///
	/// - Parameters:
	///   - of: String to replace
	///   - with: replacement String
	/// - Returns: String with replacements
	public func replaceAll(of: String, with: String) -> String {
		return self.replacingOccurrences(of: of, with: with)
	}

	/// Left trims whitespace characters
	public var lstrip: String {
		let charSet = NSCharacterSet.whitespacesAndNewlines
		let scalars = self.unicodeScalars
		let slen = scalars.count
		var drop = 0
		for i in (0..<slen) {
			if !charSet.contains(scalars[scalars.index(scalars.startIndex, offsetBy:i)]) {
				break
			}
			drop += 1
		}
		return String(self.characters.dropFirst(drop))
	}

	/// Right trims whitespace characters
	public var rstrip: String {
		let charSet = NSCharacterSet.whitespacesAndNewlines
		let scalars = self.unicodeScalars
		let slen = scalars.count
		var drop = 0
		for i in (0..<slen) {
			if !charSet.contains(scalars[scalars.index(scalars.startIndex, offsetBy:slen-i-1)]) {
				break
			}
			drop += 1
		}
		return String(self.characters.dropLast(drop))
	}

	/// Reverses the calling string
	public var reversed: String {
		return String(self.characters.reversed())
	}
}
