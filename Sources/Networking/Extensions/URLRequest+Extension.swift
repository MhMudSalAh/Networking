//
//  URLRequest+Extension.swift
//  Networking
//
//  Created by MhMuD SalAh on 13/04/2026.
//

import Foundation

extension URLRequest {
    
    init(
        configuration: any NetworkConfigProtocol,
        service: ServiceProtocol,
        cachePolicy: CachePolicy
    ) {
        let urlComponents = URLComponents(
            service: service,
            configuration: configuration
        )
        
        self.init(
            url: urlComponents.url!,
            cachePolicy: cachePolicy,
            timeoutInterval: service.timeInterval ?? configuration.timeInterval
        )
        
        httpMethod = service.method.rawValue
        
        var headers: Headers? = configuration.headers
        service.headers?.forEach { headers?[$0.key] = $0.value }
        
        if service.method != .GET && service.method != .HEAD &&
           service.method != .OPTIONS && service.method != .TRACE {
            if let files = service.media, !files.isEmpty {
                setMultipart(
                    files: files,
                    service: service,
                    configuration: configuration,
                    headers: &headers
                )
            } else if let body = service.body {
                setJSON(body: body, headers: &headers)
            }
        }
        
        if headers?.isEmpty == false {
            headers?.forEach { addValue($0.value, forHTTPHeaderField: $0.key) }
        }
    }
    
    private mutating func setMultipart(
        files: [MediaFile],
        service: ServiceProtocol,
        configuration: any NetworkConfigProtocol,
        headers: inout Headers?
    ) {
        let multipart = MultipartBuilder()
        
        var parameters: Parameters? = configuration.parameters
        service.parameters?.forEach { parameters?[$0.key] = $0.value }
        
        if let dictionary = service.body?.dictionary {
            dictionary.forEach { parameters?[$0.key] = $0.value }
        }
        
        let body = multipart.build(files: files, parameters: parameters)
        
        headers?[APIHeaderKey.contentType.rawValue] = APIHeaderValue.multipart.rawValue + multipart.boundary
        headers?[APIHeaderKey.contentLength.rawValue] = "\(body.count)"
        httpBody = body
    }
    
    private mutating func setJSON(
        body: any Encodable & Sendable,
        headers: inout Headers?
    ) {
        headers?[APIHeaderKey.contentType.rawValue] = APIHeaderValue.applicationJson.rawValue
        httpBody = try? JSONEncoder().encode(body)
    }
}
