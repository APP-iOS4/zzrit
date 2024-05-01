//
//  NotificationView.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/30/24.
//

import SwiftUI

import ZzritKit

struct NotificationView: View {
    private let notificationViewModel = NotificationViewModel.shared
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var messages: [PushMessageModel] = []
    @State private var isError: Bool = false
    
    var sortedMessages: [PushMessageModel] {
        return messages.sorted { $0.date > $1.date }
    }
    
    var body: some View {
        Rectangle()
            .foregroundStyle(.primary)
            .colorInvert()
            .frame(height: 1)
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(sortedMessages) { message in
                    NotificationCell(message: message)
                        .onTapGesture {
                            Configs.printDebugMessage("알림 셀 탭, \(message.type), \(message.targetTypeID)")
                            notificationViewModel.push.readMessage(messageID: message.id)
                            notificationViewModel.setAction(type: message.type, targetID: message.targetTypeID)
                            dismiss()
                        }
                }
            }
        }
        .navigationTitle("알림")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbarRole(.editor)
        .task {
            do {
                messages = try await notificationViewModel.push.allMessages()
            } catch {
                print("알림뷰 에러: \(error)")
                isError = true
            }
        }
    }
}

#Preview {
    NotificationView()
}
