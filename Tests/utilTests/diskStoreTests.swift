import XCTest
@testable import Util

class DiskStoreTests: XCTestCase {
    func testStore() {
        let store = DiskStore()
		
		let entry = DiskStoreEntry(values: ["foo": "bar"])
		store.set(entry)

		entry.values["foo"] = "rab"
		store.set(entry)

		let storeB = DiskStore()
		if let entryB = storeB.findForID(entry.id) {
			print(entryB.values)
			XCTAssertEqual(entryB.values["foo"] as? String, "rab")
		}
		
        XCTAssertNotNil(store)
    }

    static var allTests: [(String, (DiskStoreTests) -> () throws -> Void)] {
        return [
            ("testStore", testStore)
        ]
    }
}
