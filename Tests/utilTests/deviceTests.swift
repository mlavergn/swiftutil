import XCTest
@testable import Util

class deviceTests: XCTestCase {
	
	func testName() {
		let x = Device.name
		XCTAssertNotNil(x)
	}

	func testModel() {
		let x = App.isSimulator
		XCTAssertNotNil(x)
	}

	static var allTests : [(String, (deviceTests) -> () throws -> Void)] {
		return [
			("testName", testName),
			("testModel", testModel),
		]
	}
}
