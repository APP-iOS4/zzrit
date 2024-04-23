//
//  SearchLocationService.swift
//
//
//  Created by Sanghyeon Park on 3/26/24.
//

import Foundation

import CoreLocation

class SearchLocationService {
    static let shared = SearchLocationService()
    
    /// 설정된 스팟 로케이션
    var spotLocation: CLLocationCoordinate2D? = nil
    /// 스팟 로케이션 기준 10km 범위의 위경도 범위
    var locationRange: (minLatitude: Double, maxLatitude: Double, minLongitude: Double, maxLongitude: Double) = (0, 0, 0, 0)
    
    func setLocation(_ coordinate: CLLocationCoordinate2D?) {
        guard let coordinate else { return }
        spotLocation = coordinate
        calculateLatitudeLongitudeRange(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    /// 위도, 경도의 범위를 계산하여 반환합니다.
    /// - Parameter latitude: 기준 위도
    /// - Parameter longitude: 기준 경도
    /// - Returns: (minLatitude: Double, maxLatitude: Double, minLongitude: Double, maxLongitude: Double)
    func calculateLatitudeLongitudeRange(latitude: Double, longitude: Double) {
        let earthRadiusKm = 6371.0
        let rangeKm = 10.0

        // 위도 계산
        let latitudeRange = rangeKm / earthRadiusKm * (180.0 / .pi)
        let minLatitude = latitude - latitudeRange
        let maxLatitude = latitude + latitudeRange

        // 경도 계산
        // 경도는 위도에 따라 변화하므로, 현재 위도에서의 지구 반경을 고려하여 계산
        let maxLongitudeRange = rangeKm / (earthRadiusKm * cos(latitude * .pi / 180.0)) * (180.0 / .pi)
        let minLongitude = longitude - maxLongitudeRange
        let maxLongitude = longitude + maxLongitudeRange

        locationRange = (minLatitude, maxLatitude, minLongitude, maxLongitude)
    }
}
