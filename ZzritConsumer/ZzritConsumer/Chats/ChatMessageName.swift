//
//  ChatMessageName.swift
//  ZzritConsumer
//
//  Created by Irene on 4/15/24.
//

import SwiftUI

struct ChatMessageName: View {
    var userID: String
    var isleaderID: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            // TODO: if userId가 방장 일때
            // if message.userID == RoomModel.leaderID
            if isleaderID {
                Image(systemName: "crown.fill")
                    .font(.callout)
                    .foregroundStyle(Color.yellow)
            }
            Text(userID)
                .foregroundStyle(Color.staticGray1)
        }
    }
}

#Preview {
    ChatMessageName(userID: "민닯팽이", isleaderID: true)
}
