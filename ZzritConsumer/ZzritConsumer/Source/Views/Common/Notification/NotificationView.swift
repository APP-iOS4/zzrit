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
    
    @State private var messages: [PushMessageModel] = []
    @State private var isError: Bool = false
    
    var sortedMessages: [PushMessageModel] {
        return messages.sorted { $0.readDate == nil && $0.date < $1.date }
    }
    
    var body: some View {
        Rectangle()
            .foregroundStyle(.primary)
            .colorInvert()
            .frame(height: 1)
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(messages) { message in
                    NotificationCell(message: message)
                        .onTapGesture {
                            notificationViewModel.push.readMessage(messageID: message.id)
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
