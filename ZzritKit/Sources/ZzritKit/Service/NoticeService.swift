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
    
    // MARK: 공지사항 페이징 관련 프로퍼티
    
    /// 이어서 검색할 스냅샷
    private var lastSnapshot: QueryDocumentSnapshot? = nil
    /// 가장 마지막까지 모두 불러들였는가?
    private var isFetchEnd: Bool = false
    
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
    
    /// 공지사항을 20개씩 페이징 처리하여 불러옵니다.
    /// - Parameter isInitialFetch(Bool): true일 경우 처음부터 새로 불러옵니다.
    /// - Warning: FetchError 타입의 에러는 description 프로퍼티를 통해 에러 메세지를 확인할 수 있습니다.
    public func fetchNotice(isInitialFetch: Bool = true) async throws -> [NoticeModel] {
        do {
            // 처음 로딩의 경우 기존에 저장되어 있는 lastDocument nil
            if isInitialFetch {
                lastSnapshot = nil
                isFetchEnd = false
            }
            
            // 더이상 불러올 데이터가 없을 경우, 에러 throw
            if isFetchEnd {
                throw FetchError.noMoreFetch
            }
            
            // 기본 검색 쿼리 지정
            var noticeQuery = firebaseConst.noticeCollection.order(by: "date", descending: true).limit(to: 20)
            
            // 처음 검색이 아닐경우, 이어서 공지사항을 불러옴
            if !isInitialFetch, let lastDocument = lastSnapshot {
                noticeQuery = noticeQuery.start(afterDocument: lastDocument)
            }
            
            let snapshot = try await noticeQuery.getDocuments()
            let documents = try snapshot.documents.map { try $0.data(as: NoticeModel.self) }
            
            // 페이징을 위해 마지막 문서를 변수에 저장함
            lastSnapshot = snapshot.documents.last
            
            // 더이상 불러올 공지사항이 없다면, isFetchEnd를 true로 설정하여 검색 시도를 방지 (트래픽 낭비 방지), 에러 throw
            if lastSnapshot == nil {
                isFetchEnd = true
                throw FetchError.noMoreFetch
            }
            
            return documents
        } catch {
            throw error
        }
    }
    
    /// 공지사항을 삭제합니다.
    /// - Parameter noticeID(String): 삭제할 공지사항의 id
    public func deleteNotice(noticeID: String) async throws {
        
        // TODO: 관리자 검증 코드 추가 필요
        
        do {
            try await firebaseConst.noticeCollection.document(noticeID).delete()
        } catch {
            throw error
        }
    }
}
