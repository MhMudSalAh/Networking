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
    
    init(
        session: URLSessionProtocol,
        decoder: NetworkDecoder
    ) {
        self.session = session
        self.decoder = decoder
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
            data: &data,
            response: &response
        )
        
        #if DEBUG
        await NetworkLogger.shared.log(
            request: request,
            data: data,
            response: response,
            start: start,
            error: error
        )
        #endif
        
        return result
    }

    private func performRequest<T: Decodable & Sendable>(
        request: URLRequest,
        error: inout APIError?,
        data: inout Data?,
        response: inout URLResponse?
    ) async -> Result<T, APIError> {
        do {
            let task: (data: Data, response: URLResponse) = try await session.dataTask(request: request)
            response = task.response
            
            guard let response = task.response as? HTTPURLResponse else {
                error = APIError(type: .noResponse)
                return .failure(error!)
            }
        
            data = task.data

            let result: Result<T, APIError> = await decoder.decode(
                data: task.data,
                statusCode: response.statusCode
            )
            if case .failure(let e) = result { error = e }
            return result

        } catch let urlError {
            let mapped = mapError(urlError)
            error = mapped
            return .failure(mapped)
        }
    }

    private func mapError(_ error: Error) -> APIError {
        guard let urlError = error as? URLError else {
            return APIError(message: error.localizedDescription, type: .unknown)
        }
        switch urlError.code {
        case .notConnectedToInternet,
             .networkConnectionLost,
             .timedOut,
             .cannotFindHost,
             .cannotConnectToHost:
            return APIError(code: urlError.errorCode, message: urlError.localizedDescription, type: .network)
        case .badURL, .unsupportedURL:
            return APIError(code: urlError.errorCode, message: urlError.localizedDescription, type: .badUrl)
        default:
            return APIError(code: urlError.errorCode, message: urlError.localizedDescription, type: .unknown)
        }
    }
 }
