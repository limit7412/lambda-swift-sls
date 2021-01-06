import XCTest
@testable import lambda_swift_sls

final class lambda_swift_slsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(lambda_swift_sls().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
