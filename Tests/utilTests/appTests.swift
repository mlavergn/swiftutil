import XCTest
@testable import Util

class AppTests: XCTestCase {

	func testBundleId() {
		let x = App.bundleId
		XCTAssertNotNil(x)
	}

	func testBundleVersion() {
		let x = App.bundleVersion
		XCTAssertEqual(x, "0")
	}

	static var allTests: [(String, (AppTests) -> () throws -> Void)] {
		return [
			("testBundleId", testBundleId)
		]
	}
}
