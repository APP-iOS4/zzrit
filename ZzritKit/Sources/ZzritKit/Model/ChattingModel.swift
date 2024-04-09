//
//  File.swift
//  
//
//  Created by woong on 4/8/24.
//

import Foundation

import FirebaseFirestore

/// Chatting 모델
public struct ChattingModel: Codable, Identifiable {
    @DocumentID public var id: String? = UUID().uuidString
    /// 채팅 보낸 유저ID
    public var userID: String
    /// 채팅 보낸 시각(매번 보낸 시각자체 -> 따로 지정X)
    public var date: Date = Date()
    /// 채팅 메시지 내용
    public var message: String
    /// 채팅 메시지 타입
    public var type: ChattingType // 이거 enum으로 써야 하는지?
}
