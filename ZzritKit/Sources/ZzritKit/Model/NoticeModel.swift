//
//  NoticeModel.swift
//
//
//  Created by Sanghyeon Park on 4/8/24.
//

import Foundation

import FirebaseFirestore

/// 공지사항 모델
public struct NoticeModel: Codable, Identifiable, Equatable {
    @DocumentID public var id: String?
    /// 공지사항 제목
    public var title: String
    /// 공지사항 내용
    public var content: String
    /// 공지사항 등록 날짜
    public var date: Date
    /// 공지사항 등록 관리자 uid
    public var writerUID: String
    
    public init(id: String? = UUID().uuidString, title: String, content: String, date: Date, writerUID: String) {
        self.id = id
        self.title = title
        self.content = content
        self.date = date
        self.writerUID = writerUID
    }
}
