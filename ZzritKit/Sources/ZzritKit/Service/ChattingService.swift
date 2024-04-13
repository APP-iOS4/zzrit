//
//  ChattingService.swift
//
//
//  Created by Sanghyeon Park on 4/13/24.
//

import Foundation

import FirebaseFirestore

@available(iOS 16, *)
public final class ChattingService: ObservableObject {
    private let firebaseConst = FirebaseConstants()
    
    // MARK: Public Properties
    
    /// ChattingService가 관리할 모임 ID
    var roomID: String
    /// 채팅 메세지 기록
    @Published public private(set) var messages: [ChattingModel] = []
    
    // MARK: Private Properties
    
    private var startDocument: DocumentSnapshot?
    private var lastDocument: DocumentSnapshot?
    private var limit: Int = 30
    private var isFetchEnd: Bool = false
    private var snapshotListener: (any ListenerRegistration)? = nil
    
    public init(roomID: String) {
        self.roomID = roomID
    }
    
    deinit {
        snapshotListener = nil
    }
    
    /// 채팅 메세지를 불러옵니다.
    public func fetchChatting() async throws {
        // 기본 검색 쿼리
        let chatQuery = firebaseConst.roomChatCollection(roomID).order(by: "date").limit(toLast: limit)
        
        var requestQuery: Query
        
        if let startDocument {
            requestQuery = chatQuery.end(beforeDocument: startDocument)
        } else {
            // 처음 채팅목록을 불러올때
            requestQuery = chatQuery
        }
        
        let snapshot = try await requestQuery.getDocuments()
        
        // 쿼리 결과 문서가 없으면 그냥 페이징이 없으므로 에러 throw
        if snapshot.documents.isEmpty {
            isFetchEnd = false
            throw FetchError.noMoreFetch
        }
        
        // 현재 문서의 처음과 끝을 저장, 다음 쿼리에서 페이징하는데 이용됨
        startDocument = snapshot.documents.first
        lastDocument = snapshot.documents.last
        
        let tempMessages = try snapshot.documents.map { try $0.data(as: ChattingModel.self) }
        
        messages = tempMessages + messages
        
        if snapshotListener == nil {
            subscribeListener()
        }
    }
    
    /// 채팅 메세지를 전송합니다.
    /// - Parameters:
    ///     - uid(String): 유저의 uid
    ///     - message(String): 메시지 내용
    ///     - type(ChattingType): 메시지 타입
    /// - Important: type이 .image일 경우 message는 이미지 URL String입니다.
    public func sendMessage(uid: String, message: String, type: ChattingType) throws {
        let chatting: ChattingModel = .init(userID: uid, message: message, type: type)
        try firebaseConst.roomChatCollection(roomID).addDocument(from: chatting)
    }
    
    /// 시스템 메세지를 전송합니다.
    /// - Parameters:
    ///     - message(String): 메시지 내용
    /// - Important: type이 .image일 경우 message는 이미지 URL String입니다.
    public func sendMessage(message: String) throws {
        let chatting: ChattingModel = .init(userID: "system", message: message, type: .notice)
        try firebaseConst.roomChatCollection(roomID).addDocument(from: chatting)
    }
    
    // MARK: - Private Methods
    private func subscribeListener() {
        // 기본 검색 쿼리
        let chatQuery = firebaseConst.roomChatCollection(roomID).order(by: "date")
        
        var requestQuery: Query
        
        if let lastDocument {
            requestQuery = chatQuery.start(afterDocument: lastDocument)
        } else {
            // 처음 채팅목록을 불러올때
            requestQuery = chatQuery
        }
        
        
        // 실시간 데이터 수신을 위한 리스너 등록
        snapshotListener = requestQuery.addSnapshotListener { [weak self] snapshot, error in
            guard let documents = snapshot?.documents else {
                if let error {
                    print("Error fetching document: \(error)")
                }
                return
            }
            
            if let document = documents.last, let message = try? document.data(as: ChattingModel.self) {
                self?.messages.append(message)
            }
        }
    }
}
