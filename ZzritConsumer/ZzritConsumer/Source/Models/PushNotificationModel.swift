//
//  PushNotificationModel.swift
//  ZzritConsumer
//
//  Created by 이우석 on 4/30/24.
//

import Foundation


struct PushNotificationModel: Identifiable, Codable {
    var id = UUID().uuidString
    var title: String
    var content: String
    var date: Date
}
