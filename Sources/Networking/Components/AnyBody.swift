//
//  AnyBody.swift
//  Networking
//
//  Created by MhMuD SalAh on 08/06/2026.
//

import Foundation

public struct AnyBody: Encodable, Sendable {
    
    private let _encode: @Sendable (Encoder) throws -> Void
    
    public init(_ dict: [String: Sendable]) {
        _encode = { encoder in
            var container = encoder.container(keyedBy: StringKey.self)
            for (key, value) in dict {
                try container.encodeValue(value, forKey: StringKey(stringValue: key))
            }
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
}
