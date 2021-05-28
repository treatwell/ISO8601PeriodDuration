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

@propertyWrapper
public struct ISO8601PeriodDuration: Decodable, Equatable {
    public enum ParsingError: Error, Equatable {
        case invalidISO8601Value
    }

    public var wrappedValue: DateComponents

    public init(_ wrappedValue: DateComponents) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let iso8601Value = try container.decode(String.self)
        try self.init(iso8601Value: iso8601Value)
    }

    public init(iso8601Value: String) throws {
        wrappedValue = try Self.dateComponents(fromISO8601Value: iso8601Value)
    }
}

private extension ISO8601PeriodDuration {
    enum Const {
        /// `PnYnMnWnDTnHnMnS`
        static let validationRegex = #"^P(?:(\d*)Y)?(?:(\d*)M)?(?:(\d*)W)?(?:(\d*)D)?(?:T(?:(\d*)H)?(?:(\d*)M)?(?:(\d*)S)?)?$"#
    }

    static func dateComponents(fromISO8601Value iso8601Value: String) throws -> DateComponents {
        guard iso8601Value.range(of: Const.validationRegex, options: .regularExpression) != nil else {
            throw ParsingError.invalidISO8601Value
        }

        var dateComponents = DateComponents()

        // Gets `PnYnMnWnD` substring, then drops the `P` designator to return `nYnMnWnD`
        let periodString = String(
            iso8601Value.firstIndex(of: "T").map { iso8601Value[..<$0].dropFirst() }
            ??
            iso8601Value.dropFirst()
        )

        components(
            of: periodString,
            forRegexes: [
                "[0-9]{1,}Y",
                "[0-9]{1,}M",
                "[0-9]{1,}W",
                "[0-9]{1,}D"
            ]
        ).forEach { (key, value) in
            switch key {
            case "D": dateComponents.day = (dateComponents.day ?? 0) + value
            case "W": dateComponents.day = (dateComponents.day ?? 0) + value * 7
            case "M": dateComponents.month = value
            case "Y": dateComponents.year = value
            default: break
            }
        }

        // Gets `TnHnMnS` substring, then drops the `T` designator to return `nHnMnS`
        guard let timeString = iso8601Value
            .firstIndex(of: "T")
            .map({ iso8601Value[$0...].dropFirst() })
            .map(String.init)
        else {
            return dateComponents
        }

        components(
            of: timeString,
            forRegexes: [
                "[0-9]{1,}H",
                "[0-9]{1,}M",
                "[0-9]{1,}S"
            ]
        ).forEach { (key, value) in
            switch key {
            case "S": dateComponents.second = value
            case "M": dateComponents.minute = value
            case "H": dateComponents.hour = value
            default: break
            }
        }

        return dateComponents
    }

    static func components(of string: String, forRegexes regexes: [String]) -> [Character: Int] {
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
