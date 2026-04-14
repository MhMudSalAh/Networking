//
//  ServiceProtocol.swift
//  Networking
//
//  Created by MhMuD SalAh on 13/04/2026.
//

import Foundation

public typealias Headers = [String : String]
public typealias Parameters = [String : Any]

public protocol ServiceProtocol {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var headers: Headers? { get }
    var body: Any? { get }
    var timeInterval: TimeInterval { get }
    var urlCachePolicy: Bool { get }
}

public extension ServiceProtocol {
    var parameters: Parameters? { nil }
    var headers: Headers? { nil }
    var body: Any? { nil }
    var timeInterval: TimeInterval { 60.0 }
    var urlCachePolicy: Bool { false }
}
