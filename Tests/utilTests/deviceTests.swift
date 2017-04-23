import XCTest
@testable import Util

class DeviceTests: XCTestCase {
	func testName() {
		let x = Device.name
		XCTAssertNotNil(x)
	}

	func testModel() {
		let x = App.isSimulator
		XCTAssertNotNil(x)
	}

	static var allTests: [(String, (DeviceTests) -> () throws -> Void)] {
		return [
			("testName", testName),
			("testModel", testModel)
		]
	}
}
