/// Test for Persistence
///
/// - author: Marc Lavergne <mlavergn@gmail.com>
/// - copyright: 2017 Marc Lavergne. All rights reserved.
/// - license: MIT

import XCTest
@testable import Util

class PersistableObjectTests: XCTestCase {

    func testPersistence() {
        let dict = PersistableObject("test")
        let val = ["foo": "bar"]
        dict.set(["foo": "bar"])

        let dict2 = PersistableObject("test")

        XCTAssertEqual(dict2.get() as? [String: String] ?? [:], val)
    }

    static var allTests: [(String, (PersistableObjectTests) -> () throws -> Void)] {
        return [
            ("testPersistence", testPersistence)
        ]
    }
}
