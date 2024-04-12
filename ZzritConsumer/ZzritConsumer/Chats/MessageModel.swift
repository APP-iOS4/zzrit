//
//  messageModel.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/11/24.
//

import Foundation

//MARK: - 임시 더미 모델!!! 이건 계속 쓸 거 아님!!!!!
struct MessageModel: Identifiable {
    let id: UUID = UUID()
    let user: String
    let isYou: Bool
    let message: String
    let dateString: String
}

// 정각 알림 메시지와 공지 메시지와 참여자입장 메시지도 MessageModel에 필요
