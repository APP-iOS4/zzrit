//
//  messageModel.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/11/24.
//

import Foundation

//MARK: - 임시 더미 모델!!! 이건 계속 쓸 거 아님!!!!!
struct MessageModel {
    let id: UUID = UUID()
    let user: String
    let isYou: Bool
    let message: String
    let dateString: String
}
