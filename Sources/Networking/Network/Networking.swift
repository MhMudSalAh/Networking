//
//  Networking.swift
//  Networking
//
//  Created by MhMuD SalAh on 10/06/2026.
//

import Foundation

public enum Networking {
    
    public static func configure(with configuration: any NetworkConfigProtocol) {
        URLSessionProvider.configure(with: configuration)
    }
}
