//
//  URLComponents+Extension.swift
//  Networking
//
//  Created by MhMuD SalAh on 13/04/2026.
//

import Foundation

extension URLComponents {

    init(service: ServiceProtocol) {
        let url = APIConfig.baseURL.appendingPathComponent(service.path)
        self.init(url: url, resolvingAgainstBaseURL: false)!

        var items: [URLQueryItem] = []

        if let parameters = service.parameters {
            items += parameters.map { key, value in
                URLQueryItem(name: key, value: String(describing: value))
            }
        }

        items.append(URLQueryItem(
            name: APIHeader.apiKey.rawValue,
            value: APIConfig.apiKey
        ))

        self.queryItems = items
    }
}
