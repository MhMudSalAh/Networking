//
//  NetworkLogger.swift
//  Networking
//
//  Created by MhMuD SalAh on 05/06/2026.
//

import Foundation

#if DEBUG
actor NetworkLogger {
    static let shared = NetworkLogger()
    
    private init () {}
    
    func log(
        request: URLRequest?,
        data: Data?,
        response: URLResponse?,
        start: ContinuousClock.Instant,
        error: APIError?
    ) {
        
        let url = request?.url
        let headers = request?.allHTTPHeaderFields
        
        let body: String? = {
            guard let httpBody = request?.httpBody else { return nil }
            return String(data: httpBody, encoding: .utf8)
        }()
        
        let duration = duration(from: start)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? error?.code ?? 0
        let responseString: String? = {
            guard let data = data else { return nil }
            return String(data: data, encoding: .utf8)
        }()
        
        Console.logAPI(
            url: url?.base,
            headers: headers,
            body: body,
            parameters: url?.parameters,
            statusCode: statusCode,
            response: responseString,
            requestTime: duration,
            error: error
        )
    }
    
    private func duration(from start: ContinuousClock.Instant) -> Double {
        let duration = ContinuousClock.now - start
        return Double(duration.components.seconds) +
        Double(duration.components.attoseconds) / 1e18
    }
}
#endif
