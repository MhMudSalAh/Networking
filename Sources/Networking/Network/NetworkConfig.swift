//
//  NetworkConfig.swift
//  Networking
//
//  Created by MhMuD SalAh on 06/06/2026.
//

import Foundation

public protocol NetworkConfigProtocol: Sendable {
    var headers: Headers? { get }
    var parameters: Parameters? { get }
    var timeInterval: TimeInterval { get }
    var repeats: Int { get }
    var dateFormat: String? { get }
}

public extension NetworkConfigProtocol {
    var headers: Headers? { nil }
    var parameters: Parameters? { nil }
    var timeInterval: TimeInterval { 60 }
    var repeats: Int { 0 }
    var dateFormat: String? { nil }
}
