import XCTest
@testable import Util

class httpMultiTests: XCTestCase {
	
	func testHttpMulti() {
		let httpm = HTTPMulti()
		//httpm.standardSetup()
		
		var blob: Data?
		
		if let url: URL = Bundle.main.url(forResource: "golang", withExtension: "png") {
			print(url)
			try! blob = Data.init(contentsOf: url)
		}
		
		//httpm.test(imageData: blob!)
		
		//httpm.addTextPart(name: "metadata", text: "{\"file\": \"foo.png\"}")
		//httpm.addTextPart(name: "metadata2", text: "{\"file\": \"foo2.png\"}")
		httpm.addJSONPart(name: "meta", json: ["filename": "foo.jpg"])
		
		httpm.addBinaryPart(name: "upload", filename: "test.jpg", binary: blob!)
		
		httpm.postMultiPart(urlString: "http://127.0.0.1:8080/upload")
		
		XCTAssertNotNil(httpm)
	}
	
	static var allTests : [(String, (httpMultiTests) -> () throws -> Void)] {
		return [
			("testHttpMulti", testHttpMulti),
		]
	}
}
