//
//  ChatMessageName.swift
//  ZzritConsumer
//
//  Created by Irene on 4/15/24.
//

import SwiftUI

struct ChatMessageName: View {
    var userName: String
    var isleaderID: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            // userId가 방장 일때
            if isleaderID {
                Image(systemName: "crown.fill")
                    .font(.callout)
                    .foregroundStyle(Color.yellow)
            }
            Text(userName)
                .foregroundStyle(Color.staticGray1)
        }
    }
}

#Preview {
    ChatMessageName(userName: "민닯팽이", isleaderID: true)
}
