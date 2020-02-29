import XCTest
@testable import HouseDataScript

final class HouseDataScriptTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(HouseDataScript().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
