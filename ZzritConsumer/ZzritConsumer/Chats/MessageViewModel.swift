//
//  MessageViewModel.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/11/24.
//

import Foundation

//MARK: - 임시 더미 뷰모델!!! 이건 계속 쓸 거 아님!!!!!
class MessageViewModel {
    var messages: [MessageModel] = []
    
    static var dummyMessage: MessageModel {
        MessageModel(user: "정웅재", isYou: true, message: "안녕하세요", dateString: "오전 11:30")
    }
    
    init() {
        messages = [
            MessageModel(user: "정웅재", isYou: true, message: "안녕하세요", dateString: "오전 11:30"),
            MessageModel(user: "정웅재", isYou: true, message: "반가워여~", dateString: "오전 11:30")
        ]
    }
}
