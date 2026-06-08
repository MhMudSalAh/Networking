//
//  StringKey.swift
//  Networking
//
//  Created by MhMuD SalAh on 08/06/2026.
//

import Foundation

struct StringKey: CodingKey {
    var stringValue: String
    var intValue: Int? { nil }
    init(stringValue: String) { self.stringValue = stringValue }
    init?(intValue: Int) { nil }
}
