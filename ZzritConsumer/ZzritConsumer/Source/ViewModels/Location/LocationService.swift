//
//  LocationService.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/18/24.
//

import CoreLocation
import Foundation

class LocationService: NSObject, CLLocationManagerDelegate, ObservableObject {
    static let shared = LocationService()
    
    private let locationManager = CLLocationManager()
    
    private var userCurrentLocation: CLLocationCoordinate2D? = nil
    
    @Published private(set) var currentOffineLocation: OfflineLocationModel? = nil
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    /// 사용자의 현재 위치를 가져옵니다.
    func currentLocation() -> CLLocationCoordinate2D? {
        startLocationUpdate()
        stopLocationUpdate()
        return userCurrentLocation
    }
    
    /// 사용자에게 위치권한을 요청합니다.
    private func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    /// 현재의 위치 정보를 실시간으로 업데이트 합니다.
    private func startLocationUpdate() {
        locationManager.startUpdatingLocation()
    }
    
    /// 위치 정보 실시간 모니터링을 중지 합니다.
    private func stopLocationUpdate() {
        locationManager.stopUpdatingLocation()
    }
    
    /// 위치가 업데이트 될 때 현재 위치(좌표)를 저장합니다.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userCurrentLocation = location.coordinate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            startLocationUpdate()
        case .notDetermined:
            requestLocationAuthorization()
        default:
            // 필요한 처리를 여기에 추가
            break
        }
    }
    
    /// 현재 위치를 업데이트 합니다.
    func setCurrentLocation(_ from: OfflineLocationModel) {
        currentOffineLocation = from
        
        LocalStorage.shared.setCurrentLocation(location: from)
    }
}
