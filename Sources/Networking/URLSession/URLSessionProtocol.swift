//
//  URLSessionProtocol.swift
//  Networking
//
//  Created by MhMuD SalAh on 13/04/2026.
//

import Foundation

public protocol URLSessionProtocol {
    
    typealias DataTaskResult = (Data, URLResponse)
    
    func dataTask(request: URLRequest) async throws -> DataTaskResult
}

extension URLSession: URLSessionProtocol {
    
    public func dataTask(request: URLRequest) async throws -> DataTaskResult {
        return try await URLSession.shared.data(
            for: request,
            delegate: nil
        )
    }
}
