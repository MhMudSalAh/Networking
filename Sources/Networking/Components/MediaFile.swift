//
//  MediaFile.swift
//  Networking
//
//  Created by MhMuD SalAh on 07/06/2026.
//

import Foundation

public struct MediaFile: Sendable {
    let data: Data
    let mimeType: MimeType
    let fieldName: String
    
    var fileName: String { UUID().uuidString + mimeType.fileExtension }
    
    public init(
        data: Data,
        mimeType: MimeType,
        fieldName: String = "file"
    ) {
        self.data = data
        self.mimeType = mimeType
        self.fieldName = fieldName
    }
}
