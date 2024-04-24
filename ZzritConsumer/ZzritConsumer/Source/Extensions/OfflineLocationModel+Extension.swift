//
//  OfflineLocationModel+Extension.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/24/24.
//

import Foundation

extension OfflineLocationModel? {
    var wrappedValue: OfflineLocationModel {
        if let location = self {
            return location
        } else {
            return .initialLocation
        }
    }
}
