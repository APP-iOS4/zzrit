//
//  NoticeModel.swift
//
//
//  Created by Sanghyeon Park on 4/8/24.
//

import Foundation

import FirebaseFirestore

/// 공지사항 모델
public struct NoticeModel: Codable, Identifiable {
    @DocumentID public var id: String? = UUID().uuidString
    /// 공지사항 제목
    public var title: String
    /// 공지사항 내용
    public var content: String
    /// 공지사항 등록 날짜
    public var date: Date
    
    public init(id: String? = UUID().uuidString, title: String, content: String, date: Date) {
        self.id = id
        self.title = title
        self.content = content
        self.date = date
    }
}
