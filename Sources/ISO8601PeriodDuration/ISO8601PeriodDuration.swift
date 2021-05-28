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
public struct ISO8601PeriodDuration: Equatable {
    public var wrappedValue: DateComponents

    public init(_ wrappedValue: DateComponents) {
        self.wrappedValue = wrappedValue
    }

    public init?(rawValue: String) {
        guard let wrappedValue = DateComponents(rawISO8601PeriodDurationValue: rawValue) else {
            return nil
        }
        self.init(wrappedValue)
    }
}

extension ISO8601PeriodDuration: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        guard let duration = Self.init(rawValue: rawValue) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid `rawValue` for ISO8601PeriodDuration decoding: '\(rawValue)'"
            )
        }
        self = duration
    }
}
