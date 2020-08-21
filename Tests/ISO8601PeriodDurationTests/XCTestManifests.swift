import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ISO8601PeriodDurationTests.allTests),
    ]
}
#endif
