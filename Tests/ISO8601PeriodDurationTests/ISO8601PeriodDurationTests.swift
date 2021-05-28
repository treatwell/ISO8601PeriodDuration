//  Copyright 2021 Hotspring Ventures Ltd.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import XCTest
import ISO8601PeriodDuration

final class ISO8601PeriodDurationTests: XCTestCase {
    func testDecoding() throws {
        try assertDecodingSuccess(validPayload(), DateComponents(day: 3))
        try assertDecodingFailure(invalidPayload())
        try assertDecodingFailure(nullPayload())
        try assertDecodingFailure(missingPayload())
    }

    func testOptionalDecoding() throws {
        try assertOptionalDecodingSuccess(validPayload(), DateComponents(day: 3))
        try assertOptionalDecodingFailure(invalidPayload())
        try assertOptionalDecodingSuccess(nullPayload(), nil)
        try assertOptionalDecodingSuccess(missingPayload(), nil)
    }
}

private extension ISO8601PeriodDurationTests {
    private struct DecodableModel: Decodable {
        @ISO8601PeriodDuration var duration: DateComponents
    }

    func assertDecodingSuccess(_ payload: Data, _ dateComponents: DateComponents, line: UInt = #line) throws {
        try XCTAssertEqual(
            JSONDecoder().decode(DecodableModel.self, from: payload).duration,
            dateComponents,
            line: line
        )
    }

    func assertDecodingFailure(_ payload: Data, line: UInt = #line) throws {
        try XCTAssertThrowsError(
            JSONDecoder().decode(DecodableModel.self, from: payload),
            line: line
        ) { error in
            switch error {
            case is DecodingError:
                break
            default:
                XCTFail("Unexpected error of type '\(type(of: error))' received", line: line)
            }
        }
    }
}

private extension ISO8601PeriodDurationTests {
    private struct OptionalDecodableModel: Decodable {
        @OptionalISO8601PeriodDuration var duration: DateComponents?
    }

    func assertOptionalDecodingSuccess(_ payload: Data, _ dateComponents: DateComponents?, line: UInt = #line) throws {
        try XCTAssertEqual(
            JSONDecoder().decode(OptionalDecodableModel.self, from: payload).duration,
            dateComponents,
            line: line
        )
    }

    func assertOptionalDecodingFailure(_ payload: Data, line: UInt = #line) throws {
        try XCTAssertThrowsError(
            JSONDecoder().decode(OptionalDecodableModel.self, from: payload),
            line: line
        ) { error in
            switch error {
            case is DecodingError:
                break
            default:
                XCTFail("Unexpected error of type '\(type(of: error))' received", line: line)
            }
        }
    }
}

private extension ISO8601PeriodDurationTests {
    func validPayload(line: UInt = #line) throws -> Data {
        try payload(#"{ "duration": "P3D" }"#, line: line)
    }

    func invalidPayload(line: UInt = #line) throws -> Data {
        try payload(#"{ "duration": "abc" }"#, line: line)
    }

    func nullPayload(line: UInt = #line) throws -> Data {
        try payload(#"{ "duration": null }"#, line: line)
    }

    func missingPayload(line: UInt = #line) throws -> Data {
        try payload("{}", line: line)
    }

    private func payload(_ rawValue: String, line: UInt = #line) throws -> Data {
        try XCTUnwrap(Data(rawValue.utf8), line: line)
    }
}
