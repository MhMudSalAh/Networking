//
//  APIErrorType.swift
//  Networking
//
//  Created by MhMuD SalAh on 13/04/2026.
//

import Foundation

public enum APIErrorType: Sendable {
    case network
    case server
    case noResponse
    case noData
    case parsing
    case unAuthorized
    case unknown
}
