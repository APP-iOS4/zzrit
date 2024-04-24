//
//  CLLocationCoordinate2D+Extension.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/24/24.
//

import CoreLocation
import Foundation

extension CLLocationCoordinate2D {
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: self.latitude, longitude: self.longitude)
        return from.distance(from: to)
    }
}
