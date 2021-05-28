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

import Foundation

extension DateComponents {
    private enum Const {
        /// `PnYnMnWnDTnHnMnS`
        static let validationRegex = #"^P(?:(\d*)Y)?(?:(\d*)M)?(?:(\d*)W)?(?:(\d*)D)?(?:T(?:(\d*)H)?(?:(\d*)M)?(?:(\d*)S)?)?$"#
    }

    public init?(rawISO8601PeriodDurationValue rawValue: String) {
        guard rawValue.range(of: Const.validationRegex, options: .regularExpression) != nil else {
            return nil
        }

        var dateComponents = DateComponents()

        // Gets `PnYnMnWnD` substring, then drops the `P` designator to return `nYnMnWnD`
        let periodString = String(
            rawValue.firstIndex(of: "T").map { rawValue[..<$0].dropFirst() }
            ??
            rawValue.dropFirst()
        )

        Self.components(
            of: periodString,
            forRegexes: [
                "[0-9]{1,}Y",
                "[0-9]{1,}M",
                "[0-9]{1,}W",
                "[0-9]{1,}D"
            ]
        ).forEach { key, value in
            switch key {
            case "D": dateComponents.day = (dateComponents.day ?? 0) + value
            case "W": dateComponents.day = (dateComponents.day ?? 0) + value * 7
            case "M": dateComponents.month = value
            case "Y": dateComponents.year = value
            default: break
            }
        }

        // Gets `TnHnMnS` substring, then drops the `T` designator to return `nHnMnS`
        guard let timeString = rawValue
            .firstIndex(of: "T")
            .map({ rawValue[$0...].dropFirst() })
            .map(String.init)
        else {
            self = dateComponents
            return
        }

        Self.components(
            of: timeString,
            forRegexes: [
                "[0-9]{1,}H",
                "[0-9]{1,}M",
                "[0-9]{1,}S"
            ]
        ).forEach { key, value in
            switch key {
            case "S": dateComponents.second = value
            case "M": dateComponents.minute = value
            case "H": dateComponents.hour = value
            default: break
            }
        }

        self = dateComponents
    }

    private static func components(of string: String, forRegexes regexes: [String]) -> [Character: Int] {
        regexes.reduce(into: [:]) { components, regex in
            guard var token = try? NSRegularExpression(pattern: regex)
                .matches(in: string, range: NSRange(string.startIndex..., in: string))
                .compactMap({ String(string[Range($0.range, in: string)!]) })
                .first
            else {
                return
            }

            let key = token.removeLast()
            let value = Int(token)
            components[key] = value
        }
    }
}
