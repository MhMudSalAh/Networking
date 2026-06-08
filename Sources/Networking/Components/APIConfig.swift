//
//  APIConfig.swift
//  Networking
//
//  Created by MhMuD SalAh on 14/04/2026.
//

import Foundation

enum APIConfig {
    static var baseURL: URL {
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String,
              let url = URL(string: urlString) else {
            fatalError("Invalid BaseURL")
        }
        return url
    }
}
