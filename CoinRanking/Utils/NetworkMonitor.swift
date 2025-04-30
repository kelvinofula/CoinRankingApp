//
//  NetworkMonitor.swift
//  CoinRanking
//
//  Created by Kelvin Ofula on 4/30/25.
//

import Network

/*
 Working for both WIFI and Cellular networks
 */
class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    private(set) var isConnected: Bool = false

    private init() {
        // Immediately set isConnected to the current path status
        isConnected = monitor.currentPath.status == .satisfied
        
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }
}
