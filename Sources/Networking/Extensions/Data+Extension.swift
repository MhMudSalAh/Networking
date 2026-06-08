//
//  Data+Extension.swift
//  Networking
//
//  Created by MhMuD SalAh on 07/06/2026.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
