//
//  ChatNoticeMessageView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/25/24.
//

import SwiftUI

import ZzritKit

struct ChatNoticeMessageView: View {
    // 유저 별명 불러올때
    @EnvironmentObject private var userService: UserService
    @Environment(\.dismiss) private var dismiss
    
    @State private var showMessage = ""
    @State private var deleteChatRoom: Bool = false
    
    let message: String
    
    let room: RoomModel
    
    var body: some View {
        
        Text(showMessage)
            .foregroundStyle(Color.pointColor)
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(Color.lightPointColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .onAppear {
                Task {
                    // 문자열 파싱
                    let messageParse = message.split(separator: "_")
                    // 유저 이름 찾아오기
                    guard let userName =  try await userService.findUserInfo(uid: String(messageParse[0]))?.userName else { return }
                    showMessage = userName + "님께서 " + messageParse[1] + "하셨습니다."
                    
                    if room.leaderID == messageParse[0] && "퇴장" == messageParse[1] {
                        deleteChatRoom.toggle()
                    }
                }
            }
            .alert("방 삭제 안내", isPresented: $deleteChatRoom) {
                // 취소 버튼
                Button{
                    deleteChatRoom = false
                    dismiss()
                } label: {
                    Label("나가기", systemImage: "trash")
                        .labelStyle(.titleOnly)
                }
            } message: {
                Text("방장이 모임에서 나가게 되어 방이 삭제됩니다.")
            }
    }
    
}

//#Preview {
//    ChatNoticeMessageView(showMessage: " ", message: "Ddg8UKOLQCW8VMXxnwRTNEqFweg2_입장")
//}
