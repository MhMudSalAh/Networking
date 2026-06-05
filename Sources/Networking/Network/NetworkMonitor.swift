//
//  NetworkMonitor.swift
//  Networking
//
//  Created by MhMuD SalAh on 13/04/2026.
//

import Network
import Foundation

public enum NetworkStatus: Sendable {
    case online(ConnectionType)
    case offline
    
    public enum ConnectionType: Sendable {
        case wifi
        case cellular
        case other
    }
}

private actor NetworkState {
    var status: NetworkStatus = .online(.wifi)
    
    func update(_ newStatus: NetworkStatus) {
        status = newStatus
    }
}

public final class NetworkMonitor: Sendable {
    
    public static let shared = NetworkMonitor()
    
    private let monitor: NWPathMonitor
    private let queue: DispatchQueue
    private let state: NetworkState
    
    public let statusStream: AsyncStream<NetworkStatus>
    private let continuation: AsyncStream<NetworkStatus>.Continuation
    
    public var isOnline: Bool {
        get async {
            if case .online = await state.status { return true }
            return false
        }
    }
    
    public var currentStatus: NetworkStatus {
        get async { await state.status }
    }
    
    private init() {
        monitor = NWPathMonitor()
        queue = DispatchQueue(label: "NetworkMonitor", qos: .utility)
        state = NetworkState()
        
        var cont: AsyncStream<NetworkStatus>.Continuation!
        statusStream = AsyncStream { cont = $0 }
        continuation = cont
        
        let state = self.state
        let continuation = self.continuation
        
        monitor.pathUpdateHandler = { path in
            let status: NetworkStatus
            if path.status == .satisfied {
                if path.usesInterfaceType(.wifi) {
                    status = .online(.wifi)
                } else if path.usesInterfaceType(.cellular) {
                    status = .online(.cellular)
                } else {
                    status = .online(.other)
                }
            } else {
                status = .offline
            }
            Task {
                await state.update(status)
                continuation.yield(status)
            }
        }
        monitor.start(queue: queue)
    }
        
    deinit {
        monitor.cancel()
        continuation.finish()
    }
}
