//
//  MimeType.swift
//  Networking
//
//  Created by MhMuD SalAh on 07/06/2026.
//

import Foundation

public enum MimeType: String, Sendable {
    case jpeg = "image/jpeg"
    case png  = "image/png"
    case gif  = "image/gif"
    case mp4  = "video/mp4"
    case mov  = "video/quicktime"
    case pdf  = "application/pdf"
    
    var fileExtension: String {
        "." + rawValue.split(separator: "/").last!
            .replacingOccurrences(of: "jpeg", with: "jpg")
    }
}
