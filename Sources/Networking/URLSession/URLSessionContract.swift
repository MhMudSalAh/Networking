//
//  URLSessionContract.swift
//  Networking
//
//  Created by MhMuD SalAh on 13/04/2026.
//

import Foundation

public protocol URLSessionProviderProtocol: Sendable {
    func request<T: Decodable>(service: ServiceProtocol) async -> Result<T, APIError>
}
