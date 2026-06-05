//
//  URL+Extension.swift
//  Networking
//
//  Created by MhMuD SalAh on 05/06/2026.
//

import Foundation

extension URL {

    var base: String {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return self.absoluteString
        }
        components.query = nil
        components.fragment = nil
        return components.string ?? self.absoluteString
    }
    
    var parameters: [String: String] {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else {
            return [:]
        }
        
        return Dictionary(queryItems.map { ($0.name, $0.value ?? "") },
                          uniquingKeysWith: { (_, last) in last })
    }
}
