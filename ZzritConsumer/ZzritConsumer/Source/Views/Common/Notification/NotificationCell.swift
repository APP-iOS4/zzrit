//
//  NotificationCell.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/30/24.
//

import SwiftUI

import ZzritKit

struct NotificationCell: View {
    let message: PushMessageModel
    
    var relativeDateString: String {
        let dateString = DateService.shared.formattedString(date: message.date, format: "yyyy-MM-dd HH:mm:ss.SSS")
        return DateService.shared.relativeString(for: dateString)
    }
    
    var backgroundColor: Color {
        if let _ = message.readDate {
            return Color.clear
        } else {
            return Color.lightPointColor
        }
    }
    
    var body: some View {
        VStack(alignment:.leading, spacing: 10) {
            Text(message.title)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(message.body)
                .foregroundStyle(Color.staticGray1)
            
            Text(relativeDateString)
                .foregroundStyle(Color.staticGray3)
                .fontWeight(.bold)
        }
        .padding(Configs.paddingValue)
        .background {
            VStack {
                Spacer()
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(Color.staticGray5)
            }
            .background(backgroundColor)
        }
    }
}

#Preview {
    let message: PushMessageModel = .init(title: "채팅 알림", body: "생긴게험해 : 내일 만나는거 맞나요?", date: .now, readDate: nil, targetUID: "", senderUID: "", type: .chat, targetTypeID: "")
    return NotificationCell(message: message)
}
