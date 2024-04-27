//
//  PushTestView.swift
//  ZzritModelTest
//
//  Created by Sanghyeon Park on 4/27/24.
//

import SwiftUI

import ZzritKit

struct PushTestView: View {
    private let pushService = PushService.shared
    @State private var uid: String = ""
    @State private var title: String = ""
    @State private var pushBody: String = ""
    
    var body: some View {
        Form {
            Section("푸시 메시지 발송") {
                TextField("유저의 uid를 입력하세요.", text: $uid)
                TextField("알림 제목을 입력하세요.", text: $title)
                TextField("알림 내용을 입력하세요.", text: $pushBody)
                Button("메세지 전송") {
                    pushMessage()
                }
            }
        }
    }
    
    private func pushMessage() {
        Task {
            if let tokens = await pushService.userTokens(uid: uid) {
                print("\(tokens.count)개의 토큰이 존재함.")
                for token in tokens {
                    do {
                        try await pushService.pushMessage(to: token, title: title, body: pushBody)
                        print("1번째 메세지 발송, 수신 토큰: \(token)")
                    } catch {
                        print("푸시 발송중 에러 발생 \(error)")
                    }
                }
            }
        }
    }
}

#Preview {
    PushTestView()
}
