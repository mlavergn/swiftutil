import Foundation

/**
Swift diverged from Objective-C in how it represents strings internally. 
Objective-C had a close correlary to C strings. Swift uses grapheme
clusters, abstracting the definition of character beyond byte counts.
This causes some added work when dealing with characters.
*/

public extension String {

	/**
	Creates a string object from a UTF8 string
	*/
	public init?(validatingUTF8 cString: UnsafePointer<UInt8>) {
		guard let (s, _) = String.decodeCString(cString, as: UTF8.self, repairingInvalidCodeUnits: false) else {
			return nil
		}
		self = s
	}

	/**
	Creates a string object from a UTF8 string
	*/
	public init?(data: Data) {
		guard let (s) = String(data:data, encoding:.utf8) else {
			return nil
		}
		self = s
	}

	public var localized: String {
		return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
	}

	public var data: Data? {
		return self.data(using:.utf8)
	}

	/**
	Returns the length of the string
	*/
	public var length: Int {
		return self.characters.count
	}

	/**
	Trims leading and trailing whitespace
	*/
	public var trim: String {
		return self.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
	}

	/**
	Extracts a substring from a given index
	*/
	public func index(from: Int) -> Index {
		return self.index(startIndex, offsetBy:from)
	}

	/**
	Finds the index of a substring within a string
	*/
	public func find(_ sub: String) -> Int {
		let range = self.range(of:sub)
		if range == nil {
			return -1
		} else {
			return self.distance(from:self.startIndex, to:range!.lowerBound)
		}
	}

	/**
	Extracts a substring given a set of from / to indexes
	*/
	public func substring(from: Int, to: Int) -> String {
		let start = self.index(self.startIndex, offsetBy:from)
		let end = self.index(self.startIndex, offsetBy:to)
		let range = start..<end

		return self.substring(with: range)
	}

	/**
	Extracts the character at the given index
	*/
	func characterAt(index: Int) -> Character {
		return self[self.index(self.startIndex, offsetBy:index)]
	}

	/**
	Extracts a substring given a set of from / to indexes
	*/
	public func replaceAll(of: String, with: String) -> String {
		return self.replacingOccurrences(of: of, with: with)
	}

	/**
	Left trims whitespace characters
	*/
	func lstrip(selfx: String) -> String {
		let charSet = NSCharacterSet.whitespacesAndNewlines
		let scalars = selfx.unicodeScalars
		let slen = scalars.count
		var drop = 0
		for i in (0..<slen) {
			if !charSet.contains(scalars[scalars.index(scalars.startIndex, offsetBy:i)]) {
				break
			}
			drop += 1
		}
		return String(selfx.characters.dropFirst(drop))
	}

	/**
	Right trims whitespace characters
	*/
	func rstrip(selfx: String) -> String {
		let charSet = NSCharacterSet.whitespacesAndNewlines
		let scalars = selfx.unicodeScalars
		let slen = scalars.count
		var drop = 0
		for i in (0..<slen) {
			if !charSet.contains(scalars[scalars.index(scalars.startIndex, offsetBy:slen-i-1)]) {
				break
			}
			drop += 1
		}
		return String(selfx.characters.dropLast(drop))
	}

	/**
	Reverses a the underlying string
	*/
	public var reversed: String {
		return String(self.characters.reversed())
	}
}
