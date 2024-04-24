//
//  OfflineLocationModel.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/22/24.
//

import Foundation

class OfflineLocationModel: Identifiable, Equatable, Codable {
    static func == (lhs: OfflineLocationModel, rhs: OfflineLocationModel) -> Bool {
        return lhs.placeName == rhs.placeName && lhs.address == rhs.address && lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
    var id: String = UUID().uuidString
    var placeName: String
    var address: String
    var latitude: Double
    var longitude: Double
    
    init(placeName: String, address: String, latitude: Double, longitude: Double) {
        self.id = UUID().uuidString
        self.placeName = placeName
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
    
    static let initialLocation =  OfflineLocationModel(placeName: "광화문", address: "종로구 세종대로 172", latitude: 37.5717, longitude: 126.9765)
    
    func set(_ from: OfflineLocationModel) {
        self.placeName = from.placeName
        self.address = from.address
        self.latitude = from.latitude
        self.longitude = from.longitude
        
        LocalStorage.shared.setCurrentLocation(location: from)
    }
}
