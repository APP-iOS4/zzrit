//
//  PushNotificationView.swift
//  ZzritConsumer
//
//  Created by 이우석 on 4/30/24.
//

import SwiftUI
import ZzritKit

struct PushNotificationView: View {
    @EnvironmentObject private var notificationViewModel: NotificationViewModel
    
    @State private var isShowingAlert: Bool = false
    
    var body: some View {
        List {
            if notificationViewModel.notificationList.isEmpty {
                HStack {
                    Spacer()
                    
                    VStack {
                        Image("ZziritLogoImage")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200)
                        
                        Text("받은 알림이 없습니다. ")
                    }
                    
                    Spacer()
                }
                .padding(Configs.paddingValue)
                .listRowSeparator(.hidden)
            } else {
                ForEach(notificationViewModel.notificationList) { push in
                    VStack(alignment: .leading) {
                        Text(DateService.shared.formattedString(date: push.date))
                            .foregroundStyle(Color.staticGray3)
                        Text(push.title)
                            .fontWeight(.bold)
                        Text(push.content)
                    }
                    .padding(10)
                }
                .onDelete { indexSet in
                    notificationViewModel.deleteNotification(indices: indexSet)
                }
            }
        }
        .listStyle(.inset)
        .padding(.vertical, 5)
        .refreshable {
            notificationViewModel.refresh()
        }
        .navigationTitle("알림 목록")
        .toolbar {
            Button {
                isShowingAlert.toggle()
            } label: {
                Text("전체 삭제")
                    .foregroundStyle(notificationViewModel.notificationList.isEmpty ? Color.staticGray4 : Color.staticGray2)
            }
            .disabled(notificationViewModel.notificationList.isEmpty)
        }
        .alert("알림 전체 삭제", isPresented: $isShowingAlert) {
            Button(role: .destructive) {
                notificationViewModel.removeAllNotification()
            } label: {
                Text("삭제")
            }
        } message: {
            Text("모든 알림을 삭제하시겠습니까?")
        }
    }
}
