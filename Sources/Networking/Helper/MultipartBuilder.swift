//
//  MultipartBuilder.swift
//  Networking
//
//  Created by MhMuD SalAh on 07/06/2026.
//

import Foundation

struct MultipartBuilder: Sendable {
    
    public let boundary: String
    
    public init(boundary: String = UUID().uuidString) {
        self.boundary = boundary
    }
    
    public func build(
        files: [MediaFile],
        parameters: Parameters? = nil
    ) -> Data {
        var body = Data()
        
        parameters?.forEach { key, value in
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
        
        files.forEach { file in
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(file.fieldName)\"; filename=\"\(file.fileName)\"\r\n")
            body.append("Content-Type: \(file.mimeType.rawValue)\r\n\r\n")
            body.append(file.data)
            body.append("\r\n")
        }
        
        body.append("--\(boundary)--\r\n")
        return body
    }
}
