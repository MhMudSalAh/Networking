//
//  Repository.swift
//  Networking
//
//  Created by MhMuD SalAh on 10/06/2026.
//

import Foundation

public protocol Repository: Sendable {
    var provider: URLSessionProviderProtocol { get }
}

public extension Repository {
    var provider: URLSessionProviderProtocol { URLSessionProvider.shared }
}
