//
//  APIError.swift
//  Networking
//
//  Created by MhMuD SalAh on 13/04/2026.
//

import Foundation

public struct APIError: Error, Sendable {
    public var code: Int?
    public var message: String?
    public var type: APIErrorType?
    public var parsingDetail: ParsingDetail?
    
    public init(
        code: Int? = nil,
        message: String? = nil,
        type: APIErrorType? = nil,
        parsingDetail: ParsingDetail? = nil
    ) {
        self.code = code
        self.message = message
        self.type = type
        self.parsingDetail = parsingDetail
    }
    
    public struct ParsingDetail: Sendable {
        public let expectedType: String
        public let keyPath: String
        public let debugDescription: String
    }
}
