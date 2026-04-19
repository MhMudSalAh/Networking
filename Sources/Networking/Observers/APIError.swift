//
//  APIError.swift
//  Networking
//
//  Created by MhMuD SalAh on 13/04/2026.
//

import Foundation

public struct APIError: Error {
    var code: Int?
    var message: String?
    var type: APIErrorType?
}
