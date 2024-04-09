//
//  ContactModel.swift
//
//
//  Created by Sanghyeon Park on 4/8/24.
//

import Foundation

import FirebaseFirestore

/// 문의사항 모델
public struct ContactModel: Codable, Identifiable {
    @DocumentID public var id: String?
    /// 문의사항 타입
    public var category: ContactCategory
    /// 문의사항 제목
    public var title: String
    /// 문의사항 내용
    public var content: String
    /// 문의사항 등록 날짜
    public var requestedDated: Date
    /// 문의사항 등록 유저의 uid
    public var requestedUser: String
    /// 모임에 대한 문의인 경우 모임방 id값
    public var targetRoom: String?
    /// 유저에 대한 문의인 경우 유저의 uid 배열
    public var targetUser: [String]?
    /// 최근 답변이 등록된 날짜
    public var latestAnswerDate: Date?
    
    public init(id: String? = nil, category: ContactCategory, title: String, content: String, requestedDated: Date, requestedUser: String, targetRoom: String? = nil, targetUser: [String]? = nil, latestAnswerDate: Date? = nil) {
        self.id = id
        self.category = category
        self.title = title
        self.content = content
        self.requestedDated = requestedDated
        self.requestedUser = requestedUser
        self.targetRoom = targetRoom
        self.targetUser = targetUser
        self.latestAnswerDate = latestAnswerDate
    }
    
    public var isAnswered: Bool {
        if let _ = latestAnswerDate {
            return true
        } else {
            return false
        }
    }
}
