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
    public var category: ContactCategory
    public var title: String
    public var content: String
    public var requestedDated: Date
    public var requestedUser: String
    public var targetRoom: String?
    public var targetUser: [String]?
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
