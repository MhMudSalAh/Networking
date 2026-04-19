//
//  URLSessionProvider.swift
//  Networking
//
//  Created by MhMuD SalAh on 13/04/2026.
//

import Foundation

public final class URLSessionProvider: URLSessionProviderProtocol {
    
    private var session: URLSessionProtocol
    private var decoder: JSONDecoder
    
    public init(
        session: URLSessionProtocol = URLSession.shared,
        dateFormat: String? = nil
    ) {
        self.session = session
        self.decoder = dateFormat.map {
            let formatter = DateFormatter()
            formatter.dateFormat = $0
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .formatted(formatter)
            return decoder
        } ?? .default
    }
    
    public func request<T: Decodable>(service: ServiceProtocol) async -> Result<T, APIError> {
        let request = URLRequest(
            service: service,
            cachePolicy: urlCachePolicy(service.urlCachePolicy),
            timeoutInterval: service.timeInterval
        )
        var apiError: APIError?
        let startTime = DispatchTime.now().uptimeNanoseconds
        var task: (data: Data, response: URLResponse)?
        
        #if DEBUG
        defer {
            info(
                request: request,
                data: task?.data,
                response: task?.response,
                time: responseDuration(startTime),
                error: apiError
            )
        }
        #endif
        
        do {
            task = try await session.dataTask(request: request)
            
            guard let response = task?.response as? HTTPURLResponse else {
                apiError = APIError(type: .noResponse)
                return .failure(apiError!)
            }
            
            guard let data = task?.data else {
                apiError = APIError(type: .noData)
                return .failure(apiError!)
            }
            
            switch response.statusCode {
            case 200...299:
                guard let model = try? JSONDecoder().decode(T.self, from: data) else {
                    apiError = APIError(type: .parsing)
                    return .failure(apiError!)
                }
                return .success(model)
            case 401:
                apiError = APIError(type: .unAuthorized)
                return .failure(apiError!)
            default:
                apiError = APIError(type: .unknown)
                return .failure(apiError!)
            }
        } catch {
            apiError = APIError(message: error.localizedDescription, type: .unknown)
            return .failure(apiError!)
        }
    }
    
    private func urlCachePolicy(_ isCache: Bool) -> URLRequest.CachePolicy {
        let online = Reachability.isOnline()
        return isCache ? (online ? .reloadIgnoringCacheData : .returnCacheDataDontLoad) : .reloadIgnoringCacheData
    }
    
    private func responseDuration(_ startTime: UInt64) -> Double {
        let elapsedNanoseconds = DispatchTime.now().uptimeNanoseconds - startTime
        return (TimeInterval(elapsedNanoseconds)/1e9).rounded()
    }
    
    private func info(
        request: URLRequest?,
        data: Data?,
        response: URLResponse?,
        time: TimeInterval,
        error: APIError?
    ) {
        let url = request?.url?.absoluteString
        let headers = request?.allHTTPHeaderFields
        
        let body: String? = {
            guard let httpBody = request?.httpBody else { return nil }
            return String(data: httpBody, encoding: .utf8)
        }()
        
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        let responseString: String? = {
            guard let data = data else { return nil }
            return String(data: data, encoding: .utf8)
        }()
        
        Console.logAPI(
            url: url,
            headers: headers,
            body: body,
            statusCode: statusCode ?? 0,
            response: responseString,
            requestTime: time,
            error: error
        )
    }
}
