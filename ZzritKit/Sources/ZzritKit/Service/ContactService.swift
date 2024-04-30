//
//  ContactService.swift
//
//
//  Created by Sanghyeon Park on 4/12/24.
//

import Foundation

import FirebaseFirestore

@available(iOS 16.0.0, *)
public final class ContactService: ObservableObject {
    private let firebaseConstant = FirebaseConstants()
    
    public init() {}
    
    /// 특정 유저의 문의사항을 불러옵니다.
    /// - Parameter requestedUID(String): 문의를 작성한 유저의 UID
    /// - Returns Array(ContactModel)
    public func fetchContact(requestedUID: String) async throws -> [ContactModel] {
        let snapshot = try await firebaseConstant.contactCollection
            .whereField("requestedUser", isEqualTo: requestedUID)
            .order(by: "requestedDate", descending: true)
            .getDocuments()
        
        return try snapshot.documents.map { try $0.data(as: ContactModel.self) }
    }
    
    /// 문의사항을 삭제합니다.
    /// - Parameter contactID(String): 삭제할 문의사항 id
    public func deleteContact(contactID: String) {
        firebaseConstant.contactCollection.document(contactID).delete()
    }
    
    public func writeContact(_ contact: ContactModel) throws {
        try firebaseConstant.contactCollection.addDocument(from: contact)
    }
    
    // MARK: - Admin Service
    
    private var lastDocument: QueryDocumentSnapshot? = nil
    private var isFetchEnd: Bool = false
    
    /// 모든 문의사항을 불러옵니다.
    /// - Returns Array(ContactModel)
    /// - Warning: 관리자에서만 호출될 수 있도록 부탁드립니다.
    public func fetchContact(isInitialFetch: Bool = true) async throws -> [ContactModel] {
        do {
            // 처음 로딩의 경우 기존에 저장되어 있는 lastDocument nil
            if isInitialFetch {
                lastDocument = nil
                isFetchEnd = false
            }
            
            // 이미 모든 문서를 불러온 경우 에러 throw하여 트래픽 낭비 방지
            if isFetchEnd {
                throw FetchError.noMoreFetch
            }
            
            var query = firebaseConstant.contactCollection
                .order(by: "requestedDate", descending: true)
                .limit(to: 20)
            
            // 읽어온 문서의 기록이 있을경우 이어서 데이터를 불러오도록 쿼리를 추가한다.
            if !isInitialFetch, let lastDocument {
                query = query.start(afterDocument: lastDocument)
            }
            
            let snapshot = try await query.getDocuments()
            let documents = try snapshot.documents.map { try $0.data(as: ContactModel.self) }
            
            // 마지막 문서를 변수에 저장해둠
            lastDocument = snapshot.documents.last
            
            // 더이상 불러올 문서가 없다면 에러 throw, 트래픽 낭비 방지
            if lastDocument == nil {
                isFetchEnd = true
                throw FetchError.noMoreFetch
            }
            
            return documents
        } catch {
            throw error
        }
    }
    
    /// 해당 문의사항에 등록된 답변을 불러옵니다.
    public func fetchReplies(_ contactID: String) async throws -> [ContactReplyModel] {
        let documents = try await firebaseConstant.contactReplyCollection(contactID).order(by: "date", descending: true).getDocuments()
        return try documents.documents.map { try $0.data(as: ContactReplyModel.self) }
    }
    
    /// 문의사항에 답변을 등록합니다.
    public func writeReply(_ reply: ContactReplyModel, contactID: String, writerID: String) throws {
        try firebaseConstant.contactReplyCollection(contactID).addDocument(from: reply)
        firebaseConstant.contactCollection.document(contactID).setData(["latestAnswerDate": Date()], merge: true)
        
        Task {
            await PushService.shared.pushMessage(targetUID: writerID, title: "ZZ!RIT 문의하기", body: "문의사항 답변이 등록되었습니다. ", data: [.contact: contactID])
        }
    }
}
