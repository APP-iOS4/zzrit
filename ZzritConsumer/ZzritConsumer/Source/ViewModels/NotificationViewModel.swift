//
//  NotificationViewModel.swift
//  ZzritConsumer
//
//  Created by 이우석 on 4/30/24.
//

import Foundation

class NotificationViewModel: ObservableObject {
    @Published var notificationList: [PushNotificationModel] = []
    
    private let jsonEncoder = JSONEncoder()
    private let jsonDecoder = JSONDecoder()
    
    init() {
        fetchNotification()
    }
    
    func addNotification(title: String, content: String) {
        notificationList.insert(.init(title: title, content: content, date: Date()), at: 0)
        saveNotification()
    }
    
    func deleteNotification(indices: IndexSet) {
        notificationList.remove(atOffsets: indices)
        
        saveNotification()
    }
    
    func refresh() {
        fetchNotification()
    }
    
    func removeAllNotification() {
        notificationList.removeAll()
        
        saveNotification()
    }
    
    private func saveNotification() {
        do {
            let data: Data = try jsonEncoder.encode(notificationList)
            UserDefaults.standard.set(data, forKey: "PushNotification")
        } catch {
            Configs.printDebugMessage("JSON 생성 후 UserDefaults 저장 실패")
        }
    }
    
    private func fetchNotification() {
        do {
            if let data = UserDefaults.standard.object(forKey: "PushNotification") as? Data {
                notificationList = try jsonDecoder.decode([PushNotificationModel].self, from: data)
            }
            
            Configs.printDebugMessage(notificationList.count)
        } catch {
            Configs.printDebugMessage("JSON 생성 후 UserDefaults 읽기 실패")
        }
    }
}
