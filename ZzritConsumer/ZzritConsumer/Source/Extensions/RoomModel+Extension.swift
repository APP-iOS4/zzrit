//
//  RoomModel+Extension.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/24/24.
//

import CoreLocation
import Foundation

import ZzritKit

extension RoomModel {
    func simpleAddress() async -> String? {
        var kakaoService: KakaoSearchService? = KakaoSearchService()
        do {
            guard let placeLatitude, let placeLongitude else { return nil }
            let coordinate = CLLocationCoordinate2D(latitude: placeLatitude, longitude: placeLongitude)
            let result = try await kakaoService?.convertAddress(from: coordinate)
            
            let address: String
            if let result = result?.first {
                if let roadAddress = result.roadAddress {
                    address = "\(roadAddress.region2DepthName) \(roadAddress.roadName)"
                } else {
                    let tempAddress = result.address
                    address = "\(tempAddress.region2DepthName) \(tempAddress.region3DepthName)"
                }
                kakaoService = nil
                return address
            }
            kakaoService = nil
            return nil
        } catch {
            kakaoService = nil
            Configs.printDebugMessage("에러: \(error)")
            return nil
        }
    }
    
    func fullAddress() async -> String? {
        var kakaoService: KakaoSearchService? = KakaoSearchService()
        do {
            guard let placeLatitude, let placeLongitude else { return nil }
            let coordinate = CLLocationCoordinate2D(latitude: placeLatitude, longitude: placeLongitude)
            let result = try await kakaoService?.convertAddress(from: coordinate)
            
            let address: String
            if let result = result?.first {
                if let roadAddress = result.roadAddress {
                    address = roadAddress.addressName
                } else {
                    let tempAddress = result.address
                    address = tempAddress.addressName
                }
                kakaoService = nil
                return address
            }
            kakaoService = nil
            return nil
        } catch {
            kakaoService = nil
            Configs.printDebugMessage("에러: \(error)")
            return nil
        }
    }
    
    func distance(from: CLLocationCoordinate2D) -> Double? {
        guard let placeLatitude, let placeLongitude else { return nil }
        let coordinate = CLLocationCoordinate2D(latitude: placeLatitude, longitude: placeLongitude)
        return coordinate.distance(from: from) / 1000
    }

}
