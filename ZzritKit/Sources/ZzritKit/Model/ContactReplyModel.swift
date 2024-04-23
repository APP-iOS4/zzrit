//
//  ContactReplyModel.swift
//
//
//  Created by Sanghyeon Park on 4/8/24.
//

import Foundation

import FirebaseFirestore

/// 문의사항 답변 모델
public struct ContactReplyModel: Codable, Identifiable {
    @DocumentID public var id: String?
    /// 문의사항 답변 등록 날짜
    public var date: Date
    /// 문의사항 답변 내용
    public var content: String
    /// 문의사항 답변 등록 관리자 uid
    public var answeredAdmin: String
    
    public init(id: String? = UUID().uuidString, date: Date, content: String, answeredAdmin: String) {
        self.id = id
        self.date = date
        self.content = content
        self.answeredAdmin = answeredAdmin
    }
}
