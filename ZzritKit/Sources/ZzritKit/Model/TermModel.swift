//
//  TermModel.swift
//
//
//  Created by Sanghyeon Park on 4/13/24.
//

import Foundation

import FirebaseFirestore

public struct TermModel: Identifiable, Codable {
    @DocumentID public var id: String?
    /// 약관 시행 날짜
    public var date: Date
    /// 약관 URL
    public var urlString: String
    /// 약관 타입
    public var type: TermType
    
    public init(id: String? = nil, date: Date, urlString: String, type: TermType) {
        self.id = id
        self.date = date
        self.urlString = urlString
        self.type = type
    }
    
    /// 약관의 URL String을 URL 타입으로 반환
    public var url: URL {
        if let url = URL(string: urlString) {
            return url
        } else {
            
            // FIXME: 약관 URL 바인딩 실패시 URL 수정
            
            return URL(string: "https://www.naver.com")!
        }
    }
}
