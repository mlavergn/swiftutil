import XCTest
@testable 
import swiftutil

class swiftutilTests: XCTestCase {
    func testExample() {
    	let x = "   Hello world  "
    	let y = x.rstrip()
    	XCTAssertEqual(y, "Hello world  ")
	}
}

