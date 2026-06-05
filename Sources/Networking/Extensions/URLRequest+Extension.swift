//
//  URLRequest+Extension.swift
//  Networking
//
//  Created by MhMuD SalAh on 13/04/2026.
//

import Foundation

extension URLRequest {
    
    init(
        service: ServiceProtocol,
        cachePolicy: CachePolicy,
        timeoutInterval: TimeInterval
    ) {
        let urlComponents = URLComponents(service: service)
        self.init(
            url: urlComponents.url!,
            cachePolicy: cachePolicy,
            timeoutInterval: timeoutInterval
        )
        httpMethod = service.method.rawValue
                
        service.headers?.forEach { key, value in
            addValue(value, forHTTPHeaderField: key)
        }
                
        addValue(APIHeader.ios.rawValue, forHTTPHeaderField: APIHeader.deviceOS.rawValue)
        
        service.headers?.forEach { key, value in
            setValue(value, forHTTPHeaderField: key)
        }
        
        guard let body = service.body else { return }
        if let dict = body as? [String: Sendable] {
            let jsonObject = dict.mapValues { value -> Any in
                switch value {
                case let v as String: return v
                case let v as Int: return v
                case let v as Double: return v
                case let v as Bool: return v
                case let v as [String: Sendable]:
                    return v.mapValues { inner -> Any in
                        switch inner {
                        case let s as String: return s
                        case let i as Int: return i
                        case let d as Double: return d
                        case let b as Bool: return b
                        default: return String(describing: inner)
                        }
                    }
                case let v as [Sendable]:
                    return v.map { element -> Any in
                        switch element {
                        case let s as String: return s
                        case let i as Int: return i
                        case let d as Double: return d
                        case let b as Bool: return b
                        default: return String(describing: element)
                        }
                    }
                default:
                    return String(describing: value)
                }
            }
            httpBody = try? JSONSerialization.data(withJSONObject: jsonObject)
        }
    }
}
