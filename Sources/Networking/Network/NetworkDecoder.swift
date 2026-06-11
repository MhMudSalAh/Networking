//
//  NetworkDecoder.swift
//  Networking
//
//  Created by MhMuD SalAh on 05/06/2026.
//

import Foundation

struct NetworkDecoder: Sendable {
    
    private let decoder: JSONDecoder
    
    init(dateFormat: String? = nil) {
        self.decoder = dateFormat.map {
            let formatter = DateFormatter()
            formatter.dateFormat = $0
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(formatter)
            return decoder
        } ?? .default
    }
    
    func decode<T: Decodable & Sendable>(
        data: Data,
        statusCode: Int
    ) async -> Result<T, APIError> {
        guard let error = mapStatusCode(statusCode) else {
            return await Task.detached(priority: .userInitiated) {
                self.decodeData(T.self, from: data)
            }.value
        }
        return .failure(error)
    }
    
    private func decodeData<T: Decodable>(
        _ type: T.Type,
        from data: Data
    ) -> Result<T, APIError> {
        do {
            return .success(try decoder.decode(type, from: data))
        } catch let error as DecodingError {
            return .failure(mapDecodingError(error))
        } catch {
            return .failure(APIError(type: .parsing))
        }
    }
    
    private func mapStatusCode(_ statusCode: Int) -> APIError? {
        switch statusCode {
        case 200...299:
            nil
        case 401:
            APIError(code: statusCode, type: .unAuthorized)
        case 404:
            APIError(code: statusCode, type: .notFound)
        case 405:
            APIError(code: statusCode, type: .methodNotAllowed)
        case 400, 402, 403, 406...499:
            APIError(code: statusCode, type: .client)
        case 500...599:
            APIError(code: statusCode, type: .server)
        default:
            APIError(code: statusCode, type: .unknown)
        }
    }
    
    private func mapDecodingError(_ error: DecodingError) -> APIError {
        switch error {
        case let .typeMismatch(type, context):
            return APIError(
                type: .parsing,
                parsing: .init(
                    expectedType: String(describing: type),
                    keyPath: context.codingPath.keyPathString,
                    debugDescription: context.debugDescription
                )
            )
        case let .valueNotFound(type, context):
            return APIError(
                type: .parsing,
                parsing: .init(
                    expectedType: String(describing: type),
                    keyPath: context.codingPath.keyPathString,
                    debugDescription: context.debugDescription
                )
            )
        case let .keyNotFound(key, context):
            return APIError(
                type: .parsing,
                parsing: .init(
                    expectedType: "Optional",
                    keyPath: key.stringValue,
                    debugDescription: "Key '\(key.stringValue)' not found — \(context.debugDescription)"
                )
            )
        case let .dataCorrupted(context):
            return APIError(
                type: .parsing,
                parsing: .init(
                    expectedType: "JSON \(context.debugDescription)",
                    keyPath: context.codingPath.keyPathString ,
                    debugDescription: context.debugDescription
                )
            )
        default:
            return APIError(message: error.errorDescription, type: .parsing)
        }
    }
}
