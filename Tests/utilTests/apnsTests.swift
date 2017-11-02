/// Test for APNS
///
/// - author: Marc Lavergne <mlavergn@gmail.com>
/// - copyright: 2017 Marc Lavergne. All rights reserved.
/// - license: MIT

import XCTest
@testable import Util

class APNSTests: XCTestCase {
    
    func testStringify() {
        let token = Data(bytes: [0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xAA, 0xBB, 0xCC, 0xDD])
        let result = APNS.deviceTokenStringify(token)
        XCTAssertEqual("112233445566778899AABBCCDD", result)
    }
    
    static var allTests: [(String, (APNSTests) -> () throws -> Void)] {
        return [
            ("testStringify", testStringify)
        ]
    }
}
