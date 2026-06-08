//
//  KeyedEncodingContainer+Extension.swift
//  Networking
//
//  Created by MhMuD SalAh on 07/06/2026.
//

import Foundation

extension KeyedEncodingContainer where K == StringKey {
    mutating func encodeValue(_ value: Sendable, forKey key: StringKey) throws {
        switch value {
        case let v as String: try encode(v, forKey: key)
        case let v as Int: try encode(v, forKey: key)
        case let v as Double: try encode(v, forKey: key)
        case let v as Bool: try encode(v, forKey: key)
        case let v as [String: Sendable]:
            var nested = nestedContainer(keyedBy: StringKey.self, forKey: key)
            for (k, val) in v {
                try nested.encodeValue(val, forKey: StringKey(stringValue: k))
            }
        case let v as [Sendable]:
            var nested = nestedUnkeyedContainer(forKey: key)
            for item in v { try nested.encodeItem(item) }
        default: try encode(String(describing: value), forKey: key)
        }
    }
}

private extension UnkeyedEncodingContainer {
    mutating func encodeItem(_ value: Sendable) throws {
        switch value {
        case let v as String: try encode(v)
        case let v as Int: try encode(v)
        case let v as Double: try encode(v)
        case let v as Bool: try encode(v)
        default: try encode(String(describing: value))
        }
    }
}
