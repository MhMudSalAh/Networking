//
//  URLRequest+Extension.swift
//  Networking
//
//  Created by MhMuD SalAh on 13/04/2026.
//

import Foundation

extension URLRequest {
    
    init(service: ServiceProtocol, cachePolicy: CachePolicy, timeoutInterval: TimeInterval) {
        let urlComponents = URLComponents(service: service)
        self.init(url: urlComponents.url!, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        httpMethod = service.method.rawValue
                
        service.headers?.forEach { key, value in
            addValue(value, forHTTPHeaderField: key)
        }
                
        addValue(APIHeader.ios.rawValue, forHTTPHeaderField: APIHeader.deviceOS.rawValue)
        
        service.headers?.forEach { key, value in
            setValue(value, forHTTPHeaderField: key)
        }
        
        guard let body = service.body else { return }
        guard let dic = body as? [String: Any] else { return }
        httpBody = try? JSONSerialization.data(withJSONObject: dic)
    }
}
