//
//  APIErrorType.swift
//  Networking
//
//  Created by MhMuD SalAh on 13/04/2026.
//

import Foundation

public enum APIErrorType: String, Sendable {
    case network = "Network"
    case server = "Server"
    case notFound = "Not Found"
    case noResponse = "No Response"
    case noData = "No Data"
    case parsing = "Parsing"
    case unAuthorized = "Un Authorized"
    case client = "Client"
    case unknown = "Unknown"
    case badUrl = "Bad URL"
    case methodNotAllowed = "Method Not Allowed"
    
    var isRepeat: Bool {
        switch self {
        case .network, .noResponse:
            return true
        default:
            return false
        }
    }
}
