/// Test for Task
///
/// - author: Marc Lavergne <mlavergn@gmail.com>
/// - copyright: 2017 Marc Lavergne. All rights reserved.
/// - license: MIT

import XCTest
@testable import Util

class TaskTests: XCTestCase {

    func testExecute() {
        let cmd = "/bin/echo"
        let args = "hello"
        #if os(macOS)
        let result = Task().execute(cmd, [args])
        XCTAssertEqual("hello\n", result)
        #endif
    }

    static var allTests: [(String, (TaskTests) -> () throws -> Void)] {
        return [
            ("testExecute", testExecute)
        ]
    }
}
