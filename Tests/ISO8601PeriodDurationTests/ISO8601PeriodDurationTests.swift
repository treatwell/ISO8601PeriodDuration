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
@testable import ISO8601PeriodDuration

final class ISO8601PeriodDurationTests: XCTestCase {
    // MARK: Full
    func testFull() throws {
        try assertError("YMWDTHMS", .invalidISO8601Value)
        try assertError("3YMWDTHMS", .invalidISO8601Value) // Y
        try assertError("Y3MWDTHMS", .invalidISO8601Value) // M
        try assertError("YM3WDTHMS", .invalidISO8601Value) // W
        try assertError("YMW3DTHMS", .invalidISO8601Value) // D
        try assertError("YMWDT3HMS", .invalidISO8601Value) // H
        try assertError("YMWDTH3MS", .invalidISO8601Value) // m
        try assertError("YMWDTHM3S", .invalidISO8601Value) // S
        try assertError("3Y3M3W3DT3H3M3S", .invalidISO8601Value) // YMWDHMS

        try assert("PYMWDTHMS", DateComponents())
        try assert("P3YMWDTHMS", DateComponents(year: 3)) // Y
        try assert("PY3MWDTHMS", DateComponents(month: 3)) // M
        try assert("PYM3WDTHMS", DateComponents(day: 21)) // W
        try assert("PYMW3DTHMS", DateComponents(day: 3)) // D
        try assert("PYMWDT3HMS", DateComponents(hour: 3)) // H
        try assert("PYMWDTH3MS", DateComponents(minute: 3)) // m
        try assert("PYMWDTHM3S", DateComponents(second: 3)) // S
        try assert("P3Y3M3W3DT3H3M3S", DateComponents(year: 3, month: 3, day: 24, hour: 3, minute: 3, second: 3)) // YMWDHMS
    }

    // MARK: Period Full
    func testPeriod() throws {
        try assertError("YMWD", .invalidISO8601Value)
        try assertError("3YMWD", .invalidISO8601Value) // Y
        try assertError("Y3MWD", .invalidISO8601Value) // M
        try assertError("YM3WD", .invalidISO8601Value) // W
        try assertError("YMW3D", .invalidISO8601Value) // D
        try assertError("3Y3MWD", .invalidISO8601Value) // YM
        try assertError("YM3W3D", .invalidISO8601Value) // WD
        try assertError("3YM3WD", .invalidISO8601Value) // YW
        try assertError("3YMW3D", .invalidISO8601Value) // YD
        try assertError("3Y3M3WD", .invalidISO8601Value) // YMW
        try assertError("Y3M3W3D", .invalidISO8601Value) // MWD
        try assertError("3Y3M3W3D", .invalidISO8601Value) // YMWD

        try assert("PYMWD", DateComponents())
        try assert("P3YMWD", DateComponents(year: 3)) // Y
        try assert("PY3MWD", DateComponents(month: 3)) // M
        try assert("PYM3WD", DateComponents(day: 21)) // W
        try assert("PYMW3D", DateComponents(day: 3)) // D
        try assert("P3Y3MWD", DateComponents(year: 3, month: 3)) // YM
        try assert("PYM3W3D", DateComponents(day: 24)) // WD
        try assert("P3YM3WD", DateComponents(year: 3, day: 21)) // YW
        try assert("P3YMW3D", DateComponents(year: 3, day: 3)) // YD
        try assert("P3Y3M3WD", DateComponents(year: 3, month: 3, day: 21)) // YMW
        try assert("PY3M3W3D", DateComponents(month: 3, day: 24)) // MWD
        try assert("P3Y3M3W3D", DateComponents(year: 3, month: 3, day: 24)) // YMWD
    }

    // MARK: Period Individual
    func testYear() throws {
        try assertError("Y", .invalidISO8601Value)
        try assertError("3Y", .invalidISO8601Value)

        try assert("PY", DateComponents())
        try assert("P3Y", DateComponents(year: 3))
    }

    func testMonth() throws {
        try assertError("M", .invalidISO8601Value)
        try assertError("3M", .invalidISO8601Value)

        try assert("PM", DateComponents())
        try assert("P3M", DateComponents(month: 3))
    }

    func testWeek() throws {
        try assertError("W", .invalidISO8601Value)
        try assertError("3W", .invalidISO8601Value)

        try assert("PW", DateComponents())
        try assert("P3W", DateComponents(day: 21))
    }

    func testDay() throws {
        try assertError("D", .invalidISO8601Value)
        try assertError("3D", .invalidISO8601Value)

        try assert("PD", DateComponents())
        try assert("P3D", DateComponents(day: 3))
    }

    // MARK: Duration Full
    func testDuration() throws {
        try assertError("THMS", .invalidISO8601Value)
        try assertError("T3HMS", .invalidISO8601Value) // H
        try assertError("TH3MS", .invalidISO8601Value) // M
        try assertError("THM3S", .invalidISO8601Value) // S
        try assertError("T3H3MS", .invalidISO8601Value) // HM
        try assertError("TH3M3S", .invalidISO8601Value) // MS
        try assertError("T3HM3S", .invalidISO8601Value) // HS
        try assertError("T3H3M3S", .invalidISO8601Value) // HMS

        try assert("PTHMS", DateComponents())
        try assert("PT3HMS", DateComponents(hour: 3)) // H
        try assert("PTH3MS", DateComponents(minute: 3)) // M
        try assert("PTHM3S", DateComponents(second: 3)) // S
        try assert("PT3H3MS", DateComponents(hour: 3, minute: 3)) // HM
        try assert("PTH3M3S", DateComponents(minute: 3, second: 3)) // MS
        try assert("PT3HM3S", DateComponents(hour: 3, second: 3)) // HS
        try assert("PT3H3M3S", DateComponents(hour: 3, minute: 3, second: 3)) // HMS
    }

    // MARK: Duration Individual
    func testHour() throws {
        try assertError("H", .invalidISO8601Value)
        try assertError("TH", .invalidISO8601Value)
        try assertError("3H", .invalidISO8601Value)
        try assertError("T3H", .invalidISO8601Value)

        try assert("PTH", DateComponents())
        try assert("PT3H", DateComponents(hour: 3))
    }

    func testMinute() throws {
        try assertError("M", .invalidISO8601Value)
        try assertError("TM", .invalidISO8601Value)
        try assertError("3M", .invalidISO8601Value)
        try assertError("T3M", .invalidISO8601Value)

        try assert("PTM", DateComponents())
        try assert("PT3M", DateComponents(minute: 3))
    }

    func testSecond() throws {
        try assertError("S", .invalidISO8601Value)
        try assertError("TS", .invalidISO8601Value)
        try assertError("3S", .invalidISO8601Value)
        try assertError("T3S", .invalidISO8601Value)

        try assert("PTS", DateComponents())
        try assert("PT3S", DateComponents(second: 3))
    }

    // MARK: Edge Cases
    func testEdgeCases() throws {
        try assertError("", .invalidISO8601Value)
        try assertError(" ", .invalidISO8601Value)
        try assertError("3", .invalidISO8601Value)
        try assertError("P3", .invalidISO8601Value)
        try assertError("T3", .invalidISO8601Value)
        try assertError("PT3", .invalidISO8601Value)
        try assertError("*", .invalidISO8601Value)
        try assertError("PT3H*", .invalidISO8601Value)
        try assertError("PT3.0H", .invalidISO8601Value)
        try assertError("PT3,2H", .invalidISO8601Value)
        try assertError("PT32_H", .invalidISO8601Value)
        try assertError("PT_32H", .invalidISO8601Value)
        try assertError("PT 32H", .invalidISO8601Value)
        try assertError("PT32 H", .invalidISO8601Value)
        try assertError(" PT32H", .invalidISO8601Value)
        try assertError("PT32H ", .invalidISO8601Value)
        try assertError(" PT32H ", .invalidISO8601Value)
    }

    static var allTests = [
        ("testFull", testFull),
        ("testPeriod", testPeriod),
        ("testYear", testYear),
        ("testMonth", testMonth),
        ("testWeek", testWeek),
        ("testDay", testDay),
        ("testDuration", testDuration),
        ("testHour", testHour),
        ("testMinute", testMinute),
        ("testSecond", testSecond),
        ("testEdgeCases", testEdgeCases),
    ]
}

private extension ISO8601PeriodDurationTests {
    func assert(_ iso8601Value: String, _ rhs: DateComponents, line: UInt = #line) throws {
        try [
            ISO8601PeriodDuration(iso8601Value: iso8601Value).wrappedValue,
            JSONDecoder().decode(DecodableWithISO8601PeriodDuration.self, from: decodablePayload(iso8601Value)).duration
        ].forEach {
            XCTAssertEqual($0, rhs, line: line)
        }
    }

    func assertError(_ iso8601Value: String, _ rhs: ISO8601PeriodDuration.ParsingError, line: UInt = #line) throws {
        try [
            { try ISO8601PeriodDuration(iso8601Value: iso8601Value).wrappedValue },
            { try JSONDecoder().decode(DecodableWithISO8601PeriodDuration.self, from: self.decodablePayload(iso8601Value)).duration }
        ].forEach {
            try XCTAssertThrowsError($0(), line: line) {
                guard let lhs = $0 as? ISO8601PeriodDuration.ParsingError else {
                    XCTFail("'\(type(of: $0)).\($0)' does not match type '\(type(of: rhs))'", line: line)
                    return
                }
                XCTAssertEqual(lhs, rhs, line: line)
            }
        }
    }
}

private extension ISO8601PeriodDurationTests {
    struct DecodableWithISO8601PeriodDuration: Decodable {
        @ISO8601PeriodDuration var duration: DateComponents
    }

    func decodablePayload(_ iso8601Value: String) throws -> Data {
        try JSONSerialization.data(withJSONObject: ["duration": iso8601Value], options: [])
    }
}
