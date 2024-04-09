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
    public var date: Date
    public var content: String
    
    public init(id: String? = nil, date: Date, content: String) {
        self.id = id
        self.date = date
        self.content = content
    }
}
