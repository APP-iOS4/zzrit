//
//  ChatView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/11/24.
//

import SwiftUI

struct ChatView: View {
    //임시 뷰모델 호출
    let messageViewModel: MessageViewModel = MessageViewModel()
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack {
                    ForEach(messageViewModel.messages) { message in
                        if !message.isYou {
                            LazyVStack(alignment: .leading) {
                                ChatMessageCellView(message: message)
                            }
                        } else {
                            LazyVStack(alignment: .trailing) {
                                ChatMessageCellView(message: message)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChatView()
    }
}
