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
    public var parsing: Parsing?
    
    public init(
        code: Int? = nil,
        message: String? = nil,
        type: APIErrorType? = nil,
        parsing: Parsing? = nil
    ) {
        self.code = code
        self.message = message
        self.type = type
        self.parsing = parsing
    }
}
