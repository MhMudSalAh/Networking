//
//  URLComponents+Extension.swift
//  Networking
//
//  Created by MhMuD SalAh on 13/04/2026.
//

import Foundation

extension URLComponents {
    init(
        service: ServiceProtocol,
        configuration: any NetworkConfigProtocol
    ) {
        let url = APIConfig.baseURL.appendingPathComponent(service.path)
        self.init(url: url, resolvingAgainstBaseURL: false)!
        
        guard service.media?.isEmpty ?? true else { return }
        
        var parameters: Parameters = configuration.parameters ?? [:]
        service.parameters?.forEach { parameters[$0.key] = $0.value }
        
        guard !parameters.isEmpty else { return }
        queryItems = parameters.compactMap {
            URLQueryItem(name: $0.key, value: String(describing: $0.value))
        }
    }
}
