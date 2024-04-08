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
    
    public var isAnswered: Bool {
        if let _ = latestAnswerDate {
            return true
        } else {
            return false
        }
    }
}
