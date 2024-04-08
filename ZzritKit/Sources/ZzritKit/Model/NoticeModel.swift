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
    @DocumentID public var id: String?
    public var title: String
    public var content: String
    public var date: Date
}
