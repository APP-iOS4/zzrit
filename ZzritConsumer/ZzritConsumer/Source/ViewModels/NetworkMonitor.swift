//
//  NetworkMonitor.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/26/24.
//

import Foundation
import Network

class NetworkMonitor: ObservableObject {
    let monitor = NWPathMonitor()
    
    @Published private(set) var status: NWPath.Status
    
    init() {
        self.status = .satisfied
        
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.updateStatus(path.status)
            }
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    @MainActor
    private func updateStatus(_ newStatus: NWPath.Status) {
        status = newStatus
    }
}
