//
//  URLSessionContract.swift
//  Networking
//
//  Created by MhMuD SalAh on 13/04/2026.
//

import Foundation

protocol URLSessionProviderProtocol {
    func request<T: Decodable>(service: ServiceProtocol) async -> Result<T, APIError>
}
