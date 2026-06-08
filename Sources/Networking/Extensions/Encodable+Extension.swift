//
//  Encodable+Extension.swift
//  Networking
//
//  Created by MhMuD SalAh on 07/06/2026.
//

import Foundation

extension Encodable {
    
    var dictionary: [String: Sendable]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Sendable] }
    }
}
