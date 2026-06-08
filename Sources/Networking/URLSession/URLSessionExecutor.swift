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
        var apiError: APIError?
        let start = ContinuousClock.now
        var task: (data: Data, response: URLResponse)?
        
        do {
            task = try await session.dataTask(request: request)
            
            guard let response = task?.response as? HTTPURLResponse else {
                apiError = APIError(type: .noResponse)
                #if DEBUG
                await NetworkLogger.shared.log(
                    request: request,
                    data: nil,
                    response: task?.response,
                    start: start,
                    error: nil
                )
                #endif
                return .failure(apiError!)
            }
            
            guard let data = task?.data else {
                apiError = APIError(type: .noData)
                #if DEBUG
                await NetworkLogger.shared.log(
                    request: request,
                    data: nil,
                    response: task?.response,
                    start: start,
                    error: nil
                )
                #endif
                return .failure(apiError!)
            }
            
            switch response.statusCode {
            case 200...299:
                let decodeResult: Result<T, APIError> = await Task.detached(priority: .userInitiated) {
                    self.decoder.decode(T.self, from: data)
                }.value
                
                switch decodeResult {
                case .success(let model):
                    #if DEBUG
                    await NetworkLogger.shared.log(
                        request: request,
                        data: data,
                        response: task?.response,
                        start: start,
                        error: nil
                    )
                    #endif
                    return .success(model)
                case .failure(let error):
                    apiError = error
                    apiError?.code = response.statusCode
                    #if DEBUG
                    await NetworkLogger.shared.log(
                        request: request,
                        data: data,
                        response: task?.response,
                        start: start,
                        error: apiError
                    )
                    #endif
                    return .failure(error)
                }
                
            case 401:
                apiError = APIError(
                    code: response.statusCode,
                    type: .unAuthorized
                )
            case 404:
                apiError = APIError(
                    code: response.statusCode,
                    type: .notFound
                )
            case 405:
                apiError = APIError(
                    code: response.statusCode,
                    type: .methodNotAllowed
                )
            case 400, 402, 403, 406...499:
                apiError = APIError(
                    code: response.statusCode,
                    type: .client
                )
            case 500...599:
                apiError = APIError(
                    code: response.statusCode,
                    type: .server
                )
            default:
                apiError = APIError(
                    code: response.statusCode,
                    type: .unknown
                )
            }
            #if DEBUG
            await NetworkLogger.shared.log(
                request: request,
                data: nil,
                response: task?.response,
                start: start,
                error: apiError
            )
            #endif
            return .failure(apiError!)
        } catch let error as URLError {
            switch error.code {
            case .notConnectedToInternet, .networkConnectionLost, .timedOut, .cannotFindHost, .cannotConnectToHost:
                apiError = APIError(
                    code: error.errorCode,
                    message: error.localizedDescription,
                    type: .network
                )
            case .badURL, .unsupportedURL:
                apiError = APIError(
                    code: error.errorCode,
                    message: error.localizedDescription,
                    type: .badUrl
                )
            default:
                apiError = APIError(
                    code: error.errorCode,
                    message: error.localizedDescription,
                    type: .unknown
                )
            }
            #if DEBUG
            await NetworkLogger.shared.log(
                request: request,
                data: nil,
                response: task?.response,
                start: start,
                error: apiError
            )
            #endif
            return .failure(apiError!)
        } catch {
            apiError = APIError(
                message: error.localizedDescription,
                type: .unknown
            )
            #if DEBUG
            await NetworkLogger.shared.log(
                request: request,
                data: nil,
                response: task?.response,
                start: start,
                error: apiError
            )
            #endif
            return .failure(apiError!)
        }
    }
}
