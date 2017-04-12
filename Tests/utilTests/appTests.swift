import XCTest

class appTests: XCTestCase {

	func testBundleId() {
		let x = App.bundleId
		XCTAssertNotNil(x)
	}

	func testBundleVersion() {
		let x = App.bundleVersion
		XCTAssertEqual(x, "0")
	}

	static var allTests : [(String, (appTests) -> () throws -> Void)] {
		return [
			("testBundleId", testBundleId),
		]
	}
}
