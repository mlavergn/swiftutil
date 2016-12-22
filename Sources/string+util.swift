import Foundation

extension String { 
	func length() -> Int {
		return self.characterCount()
	}
	
	func characterCount() -> Int {
		return self.characters.count
	}

	func characterAt(index:Int) -> Character {
		return self[self.index(self.startIndex, offsetBy:index)]
	}
	
	func unicodeScalarCount() -> Int {
		return self.unicodeScalars.count
	}

	func unicodeScalarAt(index:Int) -> UnicodeScalar {
		let scalarVals = self.unicodeScalars
		return scalarVals[scalarVals.index(scalarVals.startIndex, offsetBy:index)]
	}
	
	func strip() -> String {
		return self.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
	}

	func lstrip() -> String {
		let charSet = NSCharacterSet.whitespacesAndNewlines
		var i = 0
		for j in 0..<self.unicodeScalarCount() {
			if !charSet.contains(self.unicodeScalarAt(index: j)) {
				i = j
				break
			}
		}
		
		return self.substring(from:self.index(self.startIndex, offsetBy:i))
	}
	
	func rstrip() -> String {
		let charSet = NSCharacterSet.whitespacesAndNewlines
		var i = 0
		for j in (0..<self.unicodeScalarCount()).reversed() {
			if !charSet.contains(self.unicodeScalarAt(index: j)) {
				i = j+1
				break
			}
		}
		
		return self.substring(to:self.index(self.startIndex, offsetBy:i))
	}
}
