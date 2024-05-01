//
//  NotificationViewModel.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/30/24.
//

import SwiftUI

import ZzritKit

class NotificationViewModel: ObservableObject {
    static let shared = NotificationViewModel()
    
    let push = PushService.shared
    
    @Published private(set) var notificationData: PushService.NotificationData? = nil {
        didSet {
            objectWillChange.send()
        }
    }
    
    private init() {}
    
    func setAction(type: NotificationType, targetID: String) {
        notificationData = [type: targetID]
    }
    
    func clearAction() {
        notificationData = nil
    }
}
