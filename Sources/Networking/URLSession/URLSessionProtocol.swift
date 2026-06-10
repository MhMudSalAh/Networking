//
//  URLSessionProtocol.swift
//  Networking
//
//  Created by MhMuD SalAh on 13/04/2026.
//

import Foundation

protocol URLSessionProtocol: Sendable {
    
    typealias DataTaskResult = (Data, URLResponse)
    
    func dataTask(request: URLRequest) async throws -> DataTaskResult
}

extension URLSession: URLSessionProtocol {
    
    func dataTask(request: URLRequest) async throws -> DataTaskResult {
        return try await URLSession.shared.data(
            for: request,
            delegate: nil
        )
    }
}
