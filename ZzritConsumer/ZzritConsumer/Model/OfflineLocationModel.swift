//
//  OfflineLocationModel.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/22/24.
//

import Foundation

struct OfflineLocationModel: Identifiable, Codable {
    var id: String = UUID().uuidString
    var placeName: String
    var address: String
    var latitude: Double
    var longitude: Double
}
