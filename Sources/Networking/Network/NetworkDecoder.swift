//
//  NetworkDecoder.swift
//  Networking
//
//  Created by MhMuD SalAh on 05/06/2026.
//

import Foundation

public struct NetworkDecoder: Sendable {
    
    nonisolated private let decoder: JSONDecoder
    
    public init(dateFormat: String? = nil) {
        self.decoder = dateFormat.map {
            let formatter = DateFormatter()
            formatter.dateFormat = $0
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(formatter)
            return decoder
        } ?? .default
    }
    
    func decode<T: Decodable>(
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
        @unknown default:
            return APIError(type: .parsing)
        }
    }
}
