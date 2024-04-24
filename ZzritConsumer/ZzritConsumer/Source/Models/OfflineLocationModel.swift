//
//  OfflineLocationModel.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/22/24.
//

import Foundation

struct OfflineLocationModel: Identifiable, Equatable, Codable {
    var id: String = UUID().uuidString
    var placeName: String
    var address: String
    var latitude: Double
    var longitude: Double
    
    static let initialLocation =  OfflineLocationModel(placeName: "광화문", address: "종로구 세종대로 172", latitude: 37.5717, longitude: 126.9765)
}
