//
//  JSONDecoder.swift
//  Networking
//
//  Created by MhMuD SalAh on 19/04/2026.
//

import Foundation

extension JSONDecoder {
    public static let `default`: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}
