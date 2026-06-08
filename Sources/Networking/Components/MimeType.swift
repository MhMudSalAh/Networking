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
        switch self {
        case .jpeg: return ".jpg"
        case .png:  return ".png"
        case .gif:  return ".gif"
        case .mp4:  return ".mp4"
        case .mov:  return ".mov"
        case .pdf:  return ".pdf"
        }
    }
}
