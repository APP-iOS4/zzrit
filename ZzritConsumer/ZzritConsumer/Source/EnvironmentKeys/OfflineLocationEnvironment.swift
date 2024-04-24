//
//  OfflineLocationEnvironment.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/24/24.
//

import SwiftUI

struct OfflineLocationEnvironmentKey: EnvironmentKey {
    static var defaultValue: OfflineLocationModel {
        if let latestCurrentLocation = LocalStorage.shared.latestSettedLocation() {
            return latestCurrentLocation
        } else {
            return .initialLocation
        }
    }
}

extension EnvironmentValues {
    var offlineLocation: OfflineLocationModel {
        get { self[OfflineLocationEnvironmentKey.self] }
        set { self[OfflineLocationEnvironmentKey.self] = newValue }
    }
}
