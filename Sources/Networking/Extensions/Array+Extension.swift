//
//  Array+Extension.swift
//  Networking
//
//  Created by MhMuD SalAh on 05/06/2026.
//

extension Array where Element == CodingKey {
    var keyPathString: String {
        guard !isEmpty else { return "root" }
        return map { $0.intValue.map { "[\($0)]" } ?? $0.stringValue }
            .joined(separator: ".")
    }
}
