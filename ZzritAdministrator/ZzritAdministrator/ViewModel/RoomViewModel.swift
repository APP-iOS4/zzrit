//
//  RoomViewModel.swift
//  ZzritAdministrator
//
//  Created by Healthy on 4/16/24.
//

import Foundation
import ZzritKit

@MainActor
final class RoomViewModel: ObservableObject {
    @Published var rooms: [RoomModel] = []
    
    private var initialFetch: Bool = true
    private let roomService = RoomService.shared
    
    init() {
        loadRooms()
        initialFetch = false
    }
    
    /// 모임정보 서버에서 읽어오기
    func loadRooms() {
        Task {
            do {
                rooms += try await roomService.loadRoom(isInitial: initialFetch)
                print("로드 완료")
            } catch {
                print("에러: \(error)")
            }
        }
    }
    
    
    
    /// 모임 정보를 불러옵니다.
    /// - Parameter roomID(String): 확인 할 모임 ID
    /// - Returns: RoomModel
//    public func roomInfo(_ roomID: String) async throws -> RoomModel {
//        let document = try await fbConstants.roomCollection.document(roomID).getDocument()
//        return try document.data(as: RoomModel.self)
//    }
    
    /// 모임에 참여한 유저의 목록을 불러옵니다.
    /// - Parameter roomID(String): 확인 할 모임 ID
    /// - Returns Array(UserModel)
//    public func joinedUsers(roomID: String) async throws -> [JoinedUserModel] {
//        let snapshop = try await fbConstants.joinedCollection(roomID).getDocuments()
//        return try snapshop.documents.map { try $0.data(as: JoinedUserModel.self) }
//    }
}
