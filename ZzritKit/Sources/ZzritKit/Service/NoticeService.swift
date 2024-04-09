//
//  NoticeService.swift
//
//
//  Created by Sanghyeon Park on 4/9/24.
//

import Foundation

import FirebaseFirestore

@available(iOS 16.0.0, *)
public final class NoticeService {
    private let firebaseConst = FirebaseConstants()
    
    public init() { }
    
    // MARK: - Administrator's Method
    
    /// 공지사항 등록
    public func writeNotice(_ notice: NoticeModel) throws {
        
        // TODO: 관리자 검증 코드 추가 필요
        
        do {
            try firebaseConst.noticeCollection.addDocument(from: notice)
            print("공지사항 등록 완료")
        } catch {
            throw error
        }
    }
    
    /// 공지사항을 불러옵니다.
    public func fetchNotice() async throws -> [NoticeModel] {
        do {
            let snapshot = try await firebaseConst.noticeCollection.getDocuments()
            return try snapshot.documents.map { try $0.data(as: NoticeModel.self) }
        } catch {
            throw error
        }
    }
}
