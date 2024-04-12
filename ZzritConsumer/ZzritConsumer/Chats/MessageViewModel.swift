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
        MessageModel(user: "정웅재", isYou: false, message: "안녕하세요", dateString: "오전 11:30")
    }
    
    init() {
        messages = [
            MessageModel(user: "이웃집 강아지", isYou: true, message: "안뇽하세용!!!!!", dateString: "오전 11:29"),
            MessageModel(user: "정웅재", isYou: false, message: "오!안녕하세요", dateString: "오전 11:30"),
            MessageModel(user: "정웅재", isYou: false, message: "반가워여~", dateString: "오전 11:30"),
            MessageModel(user: "이웃집 강아지", isYou: true, message: "안뇽하세용~", dateString: "오전 11:31"),
            MessageModel(user: "정웅재", isYou: false, message: "2등으로 들어오셨넹~", dateString: "오전 11:33"),
            MessageModel(user: "정웅재", isYou: false, message: "제 왼팔이 되어주십셔", dateString: "오전 11:33"),
            MessageModel(user: "이웃집 강아지", isYou: true, message: "엌ㅋㅋㅋㅋ", dateString: "오전 11:39"),
            MessageModel(user: "정웅재", isYou: false, message: "제 왼팔이 되어주십셔", dateString: "오전 11:33"),
            MessageModel(user: "이웃집 강아지", isYou: true, message: "엌ㅋㅋㅋㅋ", dateString: "오전 11:39"),
            MessageModel(user: "정웅재", isYou: false, message: "제 왼팔이 되어주십셔", dateString: "오전 11:33"),
            MessageModel(user: "이웃집 강아지", isYou: true, message: "엌ㅋㅋㅋㅋ", dateString: "오전 11:39"),
            MessageModel(user: "정웅재", isYou: false, message: "제 왼팔이 되어주십셔", dateString: "오전 11:33"),
            MessageModel(user: "이웃집 강아지", isYou: true, message: "엌ㅋㅋㅋㅋ", dateString: "오전 11:39"),
            MessageModel(user: "정웅재", isYou: false, message: "제 왼팔이 되어주십셔", dateString: "오전 11:33"),
            MessageModel(user: "이웃집 강아지", isYou: true, message: "엌ㅋㅋㅋㅋ", dateString: "오전 11:39")
        ]
    }
}
