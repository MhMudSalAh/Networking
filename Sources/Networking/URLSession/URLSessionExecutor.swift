//
//  URLSessionExecutor.swift
//  Networking
//
//  Created by MhMuD SalAh on 05/06/2026.
//

import Foundation

struct URLSessionExecutor: Sendable {
    
    private let session: URLSessionProtocol
    private let decoder: NetworkDecoder
    
    #if DEBUG
    private let logger: NetworkLogger
    #endif
    
    init(
        session: URLSessionProtocol,
        decoder: NetworkDecoder
    ) {
        self.session = session
        self.decoder = decoder
        #if DEBUG
        self.logger = NetworkLogger()
        #endif
    }
    
    func execute<T: Decodable & Sendable>(
        _ request: URLRequest
    ) async -> Result<T, APIError> {
        var error: APIError?
        var data: Data?
        var response: URLResponse?
        let start = ContinuousClock.now
        
        let result: Result<T, APIError> = await performRequest(
            request: request,
            error: &error,
            capturedData: &data,
            response: &response
        )
        
        #if DEBUG
        let safeError = error
        let safeData = data
        let safeResponse = response
        
        await NetworkLogger.shared.log(
            request: request,
            data: safeData,
            response: safeResponse,
            start: start,
            error: safeError
        )
        #endif
        
        return result
    }

    private func performRequest<T: Decodable & Sendable>(
        request: URLRequest,
        error: inout APIError?,
        capturedData: inout Data?,
        response: inout URLResponse?
    ) async -> Result<T, APIError> {
        do {
            let task: (data: Data, response: URLResponse)? = try await session.dataTask(request: request)
            response = task?.response
            
            guard let response = task?.response as? HTTPURLResponse else {
                error = APIError(type: .noResponse)
                return .failure(error!)
            }
            
            guard let data = task?.data else {
                error = APIError(type: .noData)
                return .failure(error!)
            }
            
            capturedData = data
            
            switch response.statusCode {
            case 200...299:
                let decodeResult: Result<T, APIError> = await Task.detached(priority: .userInitiated) {
                    self.decoder.decode(T.self, from: data)
                }.value
                
                switch decodeResult {
                case .success(let model):
                    return .success(model)
                case .failure(let e):
                    error = e
                    error?.code = response.statusCode
                    return .failure(error!)
                }
                
            case 401:
                error = APIError(code: response.statusCode, type: .unAuthorized)
            case 404:
                error = APIError(code: response.statusCode, type: .notFound)
            case 405:
                error = APIError(code: response.statusCode, type: .methodNotAllowed)
            case 400, 402, 403, 406...499:
                error = APIError(code: response.statusCode, type: .client)
            case 500...599:
                error = APIError(code: response.statusCode, type: .server)
            default:
                error = APIError(code: response.statusCode, type: .unknown)
            }
            return .failure(error!)
        } catch let e as URLError {
            switch e.code {
            case .notConnectedToInternet, .networkConnectionLost, .timedOut, .cannotFindHost, .cannotConnectToHost:
                error = APIError(
                    code: e.errorCode,
                    message: e.localizedDescription,
                    type: .network
                )
            case .badURL, .unsupportedURL:
                error = APIError(
                    code: e.errorCode,
                    message: e.localizedDescription,
                    type: .badUrl
                )
            default:
                error = APIError(
                    code: e.errorCode,
                    message: e.localizedDescription,
                    type: .unknown
                )
            }
            return .failure(error!)
        } catch let e {
            error = APIError(message: e.localizedDescription, type: .unknown)
            return .failure(error!)
        }
    }
 }
