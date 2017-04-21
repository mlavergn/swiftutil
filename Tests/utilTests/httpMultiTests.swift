import XCTest
@testable import Util

class httpMultiTests: XCTestCase {
	
	func testHttpMulti() {
		let httpm = HTTPMulti()
		//httpm.standardSetup()
		
		var blob: Data?
		
		
		if !App.isSandboxed {
			guard var url = URL(string:"file://" + FileManager.default.currentDirectoryPath) else {
				XCTAssertFalse(true, "unable to obtain current working directory")
				return
			}
			url.appendPathComponent("Tests/mayhem.jpg")
			try! blob = Data.init(contentsOf: url)
		} else {
			blob = Images.imageToData(name: "mayhem.jpg")
		}
		
		XCTAssertFalse(blob == nil || blob!.count == 0, "Could not load image")
		
		httpm.addJSONPart(name: "meta", json: ["filename": "mayhemJ.jpg"])
		
		httpm.addBinaryPart(name: "upload", filename: "mayhemB.jpg", binary: blob!)
		
		let json = httpm.postMultiPart(urlString: "http://127.0.0.1:8080/upload")
		XCTAssertNotNil(json)
	}
	
	static var allTests : [(String, (httpMultiTests) -> () throws -> Void)] {
		return [
			("testHttpMulti", testHttpMulti),
		]
	}
}
