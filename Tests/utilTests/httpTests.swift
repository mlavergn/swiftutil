import XCTest
@testable import Util

class HTTPTests: XCTestCase {
	func testHttp() {
		let http = HTTP()
		let content = http.getHTML(urlString: "http://iot.reqly.com")
		XCTAssertNotNil(content)
	}

	static var allTests: [(String, (HTTPTests) -> () throws -> Void)] {
		return [
			("testHttpMulti", testHttp)
		]
	}
}
