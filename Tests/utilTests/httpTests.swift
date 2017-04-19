import XCTest
@testable import Util

class httpTests: XCTestCase {
	
	func testHttp() {
		let http = HTTP()
		let content = http.getHTML(urlString: "http://iot.reqly.com")
		
		XCTAssertNotNil(content)
	}
	
	static var allTests : [(String, (httpTests) -> () throws -> Void)] {
		return [
			("testHttpMulti", testHttp),
		]
	}
}
