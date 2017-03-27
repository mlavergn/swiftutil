import XCTest
@testable import Util

class jsonTests: XCTestCase {

	func testDecode() {
		// This is an example of a functional test case.
		// Use XCTAssert and related functions to verify your tests produce the correct results.
		let x = JSON.decodeString("{\"a\":1}")
		XCTAssertNotNil(x)
		let y = x!["a"]
		XCTAssertNotNil(y)
		XCTAssertEqual(y as! Int, 1)
	}

	func testEncode() {
		// This is an example of a functional test case.
		// Use XCTAssert and related functions to verify your tests produce the correct results.
		let x = JSON.encodeAsString(["a": 1])
		XCTAssertNotNil(x)
		XCTAssertEqual(x, "{\"a\":1}")
	}

	static var allTests : [(String, (jsonTests) -> () throws -> Void)] {
		return [
			("testDecode", testDecode),
			("testEncode", testEncode),
		]
	}
}
