//
//  URLSessionProvider.swift
//  Networking
//
//  Created by MhMuD SalAh on 13/04/2026.
//

import Foundation

import Foundation

public actor URLSessionProvider: URLSessionProviderProtocol {
    
    private let session: URLSessionProtocol
    private let requestBuilder: RequestBuilder
    private let decoder: ResponseDecoder
    
    #if DEBUG
    private let logger: NetworkLogger
    #endif
    
    public init(
        session: URLSessionProtocol = URLSession.shared,
        dateFormat: String? = nil
    ) {
        self.session = session
        self.requestBuilder = RequestBuilder()
        self.decoder = ResponseDecoder(dateFormat: dateFormat)
        
        #if DEBUG
        self.logger = NetworkLogger()
        #endif
    }
    
    public func request<T: Decodable & Sendable>(service: ServiceProtocol) async -> Result<T, APIError> {
        let request = await requestBuilder.build(from: service)
        var apiError: APIError?
        let start = ContinuousClock.now
        var task: (data: Data, response: URLResponse)?
        
        #if DEBUG
        defer {
            logger.log(
                request: request,
                data: task?.data,
                response: task?.response,
                start: start,
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
                let decodeResult: Result<T, APIError> = await Task.detached(priority: .userInitiated) {
                    self.decoder.decode(T.self, from: data)
                }.value
                
                switch decodeResult {
                case .success(let model):
                    return .success(model)
                case .failure(let error):
                    apiError = error
                    return .failure(error)
                }
                
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
}
