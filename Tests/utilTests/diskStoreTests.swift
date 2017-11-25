import XCTest
@testable import Util

class DiskStoreTests: XCTestCase {
    func testStore() {
        let x = DiskStore()
        XCTAssertNotNil(x)
    }

    static var allTests: [(String, (DiskStoreTests) -> () throws -> Void)] {
        return [
            ("testStore", testStore)
        ]
    }
}
