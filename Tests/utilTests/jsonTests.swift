import XCTest
@testable import Util

class jsonTests: XCTestCase {
	func testDecodeFromString() {
		// This is an example of a functional test case.
		// Use XCTAssert and related functions to verify your tests produce the correct results.
		let x = JSON.decodeFromString("{\"a\":1}")
		XCTAssertNotNil(x)
		let y = x!["a"]
		XCTAssertNotNil(y)
		XCTAssertEqual(y as! Int, 1)
	}


	static var allTests : [(String, (jsonTests) -> () throws -> Void)] {
		return [
			("testDecodeFromString", testDecodeFromString),
		]
	}
}
