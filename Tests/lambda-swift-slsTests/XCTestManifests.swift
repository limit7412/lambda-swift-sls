import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(lambda_swift_slsTests.allTests),
    ]
}
#endif
