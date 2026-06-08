//
//  ServiceProtocol.swift
//  Networking
//
//  Created by MhMuD SalAh on 13/04/2026.
//

import Foundation

public typealias Headers = [String : String]
public typealias Parameters = [String : Sendable]

public protocol ServiceProtocol: Sendable {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var headers: Headers? { get }
    var body: (any Encodable & Sendable)? { get }
    var media: [MediaFile]? { get }
    var timeInterval: TimeInterval? { get }
    var urlCachePolicy: Bool { get }
    var repeats: Int? { get }
}

public extension ServiceProtocol {
    var parameters: Parameters? { nil }
    var headers: Headers? { nil }
    var body: (any Encodable & Sendable)? { nil }
    var media: [MediaFile]? { nil }
    var timeInterval: TimeInterval? { nil }
    var urlCachePolicy: Bool { false }
    var repeats: Int? { nil }
}
