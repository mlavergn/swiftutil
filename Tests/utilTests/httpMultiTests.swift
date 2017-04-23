import XCTest
@testable import Util

class HTTPMultiTests: XCTestCase {
	func testHttpMulti() {
		let httpm = HTTPMulti()
		var blob: Data?

		if !App.isSandboxed {
			guard var url = URL(string:"file://" + FileManager.default.currentDirectoryPath) else {
				XCTAssertFalse(true, "unable to obtain current working directory")
				return
			}
			url.appendPathComponent("Tests/mayhem.jpg")
			do {
				try blob = Data.init(contentsOf: url)
			} catch {
				XCTAssertFalse(true, "Failed to load image")
			}
		} else {
			blob = Images.imageToData(name: "mayhem.jpg")
		}

		XCTAssertFalse(blob == nil || blob!.count == 0, "Could not load image")

		httpm.addJSONPart(name: "meta", json: ["filename": "mayhemJ.jpg"])

		httpm.addBinaryPart(name: "upload", filename: "mayhemB.jpg", binary: blob!)

		let json = httpm.postMultiPart(urlString: "http://127.0.0.1:8080/upload")
		XCTAssertNotNil(json)
	}

	static var allTests: [(String, (HTTPMultiTests) -> () throws -> Void)] {
		return [
			("testHttpMulti", testHttpMulti)
		]
	}
}
