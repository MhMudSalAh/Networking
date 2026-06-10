//
//  URLSessionProvider.swift
//  Networking
//
//  Created by MhMuD SalAh on 13/04/2026.
//

import Foundation

struct URLSessionProvider: URLSessionProviderProtocol {
    
    static let shared = URLSessionProvider()
    private let requestBuilder: NetworkBuilder
    private let executor: URLSessionExecutor
    
    private struct NetworkConfig: NetworkConfigProtocol {}
    nonisolated(unsafe) private static var _configuration: any NetworkConfigProtocol = NetworkConfig()

    static func configure(with configuration: any NetworkConfigProtocol) {
        _configuration = configuration
    }
    
    private init(session: URLSessionProtocol = URLSession.shared) {
        self.requestBuilder = NetworkBuilder(configuration: Self._configuration)
        self.executor = URLSessionExecutor(
            session: session,
            decoder: NetworkDecoder(dateFormat: Self._configuration.dateFormat)
        )
    }
    
    public func request<T: Decodable & Sendable>(service: ServiceProtocol) async -> Result<T, APIError> {
        let request = await requestBuilder.build(from: service)
        let repeats = service.repeats ?? Self._configuration.repeats
        var attempt = 0
        
        repeat {
            let result: Result<T, APIError> = await executor.execute(request)
            switch result {
            case .success:
                return result
            case .failure(let error):
                guard attempt < repeats,
                      error.type?.isRepeat == true else {
                    return result
                }
                attempt += 1
                try? await Task.sleep(for: .seconds(pow(2.0, Double(attempt - 1))))
            }
        } while true
    }
}
