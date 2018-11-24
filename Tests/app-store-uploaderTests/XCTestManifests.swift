import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(app_store_uploaderTests.allTests),
    ]
}
#endif