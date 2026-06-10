//
//  NetworkBuilder.swift
//  Networking
//
//  Created by MhMuD SalAh on 05/06/2026.
//

import Foundation

struct NetworkBuilder: Sendable {
    
    private let configuration: any NetworkConfigProtocol
    private let monitor: NetworkMonitor
    
    public init(
        configuration: any NetworkConfigProtocol,
        monitor: NetworkMonitor = .shared
    ) {
        self.configuration = configuration
        self.monitor = monitor
    }
    
    func build(from service: ServiceProtocol) async -> URLRequest {
        let cachePolicy = await cachePolicy(service.urlCachePolicy)
        return URLRequest(
            configuration: configuration,
            service: service,
            cachePolicy: cachePolicy
        )
    }
    
    private func cachePolicy(_ isCache: Bool) async -> URLRequest.CachePolicy {
        let online = await monitor.isOnline
        return isCache
            ? (online ? .reloadIgnoringCacheData : .returnCacheDataDontLoad)
            : .reloadIgnoringCacheData
    }
}
