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

final class DateComponents_ISO8601Tests: XCTestCase {
    // MARK: Full
    func testFull() throws {
        assert("YMWDTHMS", nil)
        assert("3YMWDTHMS", nil) // Y
        assert("Y3MWDTHMS", nil) // M
        assert("YM3WDTHMS", nil) // W
        assert("YMW3DTHMS", nil) // D
        assert("YMWDT3HMS", nil) // H
        assert("YMWDTH3MS", nil) // m
        assert("YMWDTHM3S", nil) // S
        assert("3Y3M3W3DT3H3M3S", nil) // YMWDHMS

        assert("PYMWDTHMS", DateComponents())
        assert("P3YMWDTHMS", DateComponents(year: 3)) // Y
        assert("PY3MWDTHMS", DateComponents(month: 3)) // M
        assert("PYM3WDTHMS", DateComponents(day: 21)) // W
        assert("PYMW3DTHMS", DateComponents(day: 3)) // D
        assert("PYMWDT3HMS", DateComponents(hour: 3)) // H
        assert("PYMWDTH3MS", DateComponents(minute: 3)) // m
        assert("PYMWDTHM3S", DateComponents(second: 3)) // S
        assert("P3Y3M3W3DT3H3M3S", DateComponents(year: 3, month: 3, day: 24, hour: 3, minute: 3, second: 3)) // YMWDHMS
    }

    // MARK: Period Full
    func testPeriod() throws {
        assert("YMWD", nil)
        assert("3YMWD", nil) // Y
        assert("Y3MWD", nil) // M
        assert("YM3WD", nil) // W
        assert("YMW3D", nil) // D
        assert("3Y3MWD", nil) // YM
        assert("YM3W3D", nil) // WD
        assert("3YM3WD", nil) // YW
        assert("3YMW3D", nil) // YD
        assert("3Y3M3WD", nil) // YMW
        assert("Y3M3W3D", nil) // MWD
        assert("3Y3M3W3D", nil) // YMWD

        assert("PYMWD", DateComponents())
        assert("P3YMWD", DateComponents(year: 3)) // Y
        assert("PY3MWD", DateComponents(month: 3)) // M
        assert("PYM3WD", DateComponents(day: 21)) // W
        assert("PYMW3D", DateComponents(day: 3)) // D
        assert("P3Y3MWD", DateComponents(year: 3, month: 3)) // YM
        assert("PYM3W3D", DateComponents(day: 24)) // WD
        assert("P3YM3WD", DateComponents(year: 3, day: 21)) // YW
        assert("P3YMW3D", DateComponents(year: 3, day: 3)) // YD
        assert("P3Y3M3WD", DateComponents(year: 3, month: 3, day: 21)) // YMW
        assert("PY3M3W3D", DateComponents(month: 3, day: 24)) // MWD
        assert("P3Y3M3W3D", DateComponents(year: 3, month: 3, day: 24)) // YMWD
    }

    // MARK: Period Individual
    func testYear() throws {
        assert("Y", nil)
        assert("3Y", nil)

        assert("PY", DateComponents())
        assert("P3Y", DateComponents(year: 3))
    }

    func testMonth() throws {
        assert("M", nil)
        assert("3M", nil)

        assert("PM", DateComponents())
        assert("P3M", DateComponents(month: 3))
    }

    func testWeek() throws {
        assert("W", nil)
        assert("3W", nil)

        assert("PW", DateComponents())
        assert("P3W", DateComponents(day: 21))
    }

    func testDay() throws {
        assert("D", nil)
        assert("3D", nil)

        assert("PD", DateComponents())
        assert("P3D", DateComponents(day: 3))
    }

    // MARK: Duration Full
    func testDuration() throws {
        assert("THMS", nil)
        assert("T3HMS", nil) // H
        assert("TH3MS", nil) // M
        assert("THM3S", nil) // S
        assert("T3H3MS", nil) // HM
        assert("TH3M3S", nil) // MS
        assert("T3HM3S", nil) // HS
        assert("T3H3M3S", nil) // HMS

        assert("PTHMS", DateComponents())
        assert("PT3HMS", DateComponents(hour: 3)) // H
        assert("PTH3MS", DateComponents(minute: 3)) // M
        assert("PTHM3S", DateComponents(second: 3)) // S
        assert("PT3H3MS", DateComponents(hour: 3, minute: 3)) // HM
        assert("PTH3M3S", DateComponents(minute: 3, second: 3)) // MS
        assert("PT3HM3S", DateComponents(hour: 3, second: 3)) // HS
        assert("PT3H3M3S", DateComponents(hour: 3, minute: 3, second: 3)) // HMS
    }

    // MARK: Duration Individual
    func testHour() throws {
        assert("H", nil)
        assert("TH", nil)
        assert("3H", nil)
        assert("T3H", nil)

        assert("PTH", DateComponents())
        assert("PT3H", DateComponents(hour: 3))
    }

    func testMinute() throws {
        assert("M", nil)
        assert("TM", nil)
        assert("3M", nil)
        assert("T3M", nil)

        assert("PTM", DateComponents())
        assert("PT3M", DateComponents(minute: 3))
    }

    func testSecond() throws {
        assert("S", nil)
        assert("TS", nil)
        assert("3S", nil)
        assert("T3S", nil)

        assert("PTS", DateComponents())
        assert("PT3S", DateComponents(second: 3))
    }

    // MARK: Edge Cases
    func testEdgeCases() throws {
        assert("", nil)
        assert(" ", nil)
        assert("3", nil)
        assert("P3", nil)
        assert("T3", nil)
        assert("PT3", nil)
        assert("*", nil)
        assert("PT3H*", nil)
        assert("PT3.0H", nil)
        assert("PT3,2H", nil)
        assert("PT32_H", nil)
        assert("PT_32H", nil)
        assert("PT 32H", nil)
        assert("PT32 H", nil)
        assert(" PT32H", nil)
        assert("PT32H ", nil)
        assert(" PT32H ", nil)
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

private extension DateComponents_ISO8601Tests {
    func assert(_ rawValue: String, _ dateComponents: DateComponents?, line: UInt = #line) {
        XCTAssertEqual(
            DateComponents(rawISO8601PeriodDurationValue: rawValue),
            dateComponents,
            line: line
        )
    }
}
