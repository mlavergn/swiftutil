import XCTest
@testable import Util

class JSONTests: XCTestCase {

	func testDecode() {
		// This is an example of a functional test case.
		// Use XCTAssert and related functions to verify your tests produce the correct results.
		let x = JSON.decodeString("{\"a\":1}")
		XCTAssertNotNil(x)
		if let y = x?["a"] {
			XCTAssertNotNil(y)
			if let z = y as? Int {
				XCTAssertEqual(z, 1)
			} else {
				XCTAssertFalse(true, "Unexpected Int conversion failure in JSON payload")
			}
		} else {
			XCTAssertFalse(true, "Failed to decode JSON")
		}
	}

	func testEncode() {
		// This is an example of a functional test case.
		// Use XCTAssert and related functions to verify your tests produce the correct results.
		let x = JSON.encodeAsString(["a": 1])
		XCTAssertNotNil(x)
		XCTAssertEqual(x, "{\"a\":1}")
	}

	static var allTests: [(String, (JSONTests) -> () throws -> Void)] {
		return [
			("testDecode", testDecode),
			("testEncode", testEncode)
		]
	}
}
