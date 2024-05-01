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
        let sortedNilFiltered = messages.filter { $0.readDate == nil }.sorted { $0.date > $1.date }
        let sortedSomeFiltered = messages.filter { $0.readDate != nil }.sorted { $0.date > $1.date }
        
        return sortedNilFiltered + sortedSomeFiltered
    }
    
    var body: some View {
        Rectangle()
            .foregroundStyle(.primary)
            .colorInvert()
            .frame(height: 1)
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
        
        if sortedMessages.isEmpty {
            Spacer()
            Image("ZziritLogoImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200)
            
            Text("알림 메세지가 없습니다.")
            
            Spacer()
        } else {
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
        }
    }
}

#Preview {
    NotificationView()
}
