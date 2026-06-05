//
//  RequestBuilder.swift
//  Networking
//
//  Created by MhMuD SalAh on 05/06/2026.
//

import Foundation

public struct RequestBuilder: Sendable {
    
    private let monitor: NetworkMonitor
    
    public init(monitor: NetworkMonitor = .shared) {
        self.monitor = monitor
    }
    
    func build(from service: ServiceProtocol) async -> URLRequest {
        let cachePolicy = await cachePolicy(service.urlCachePolicy)
        return URLRequest(
            service: service,
            cachePolicy: cachePolicy,
            timeoutInterval: service.timeInterval
        )
    }
    
    private func cachePolicy(_ isCache: Bool) async -> URLRequest.CachePolicy {
        let online = await monitor.isOnline
        return isCache
            ? (online ? .reloadIgnoringCacheData : .returnCacheDataDontLoad)
            : .reloadIgnoringCacheData
    }
}
