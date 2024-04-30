//
//  NotificationViewModel.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/30/24.
//

import Foundation

import ZzritKit

class NotificationViewModel {
    static let shared = NotificationViewModel()
    
    let push = PushService.shared
    
    private init() {}
    
    
}
