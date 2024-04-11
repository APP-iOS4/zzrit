//
//  MessageViewModel.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/11/24.
//

import Foundation

class MessageViewModel {
    var messages: [MessageModel] = []
    
    init() {
        messages = [
            MessageModel(message: "안녕하세요", date: "2024/02/22"),
            MessageModel(message: "반가워여~", date: "2024/02/22")
        ]
    }
}
