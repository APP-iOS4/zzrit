//
//  ChatView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/11/24.
//

import SwiftUI

struct ChatView: View {
    // 입력 메세지 변수
    @State private var messageText: String = ""
    //임시 뷰모델 호출
    let messageViewModel: MessageViewModel = MessageViewModel()
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack {
                    ForEach(messageViewModel.messages) { message in
                        // 메세지가 상대방일 경우
                        if !message.isYou {
                            LazyVStack(alignment: .leading) {
                                ChatMessageCellView(message: message)
                            }
                        //  메세지가 내꺼일 경우
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
