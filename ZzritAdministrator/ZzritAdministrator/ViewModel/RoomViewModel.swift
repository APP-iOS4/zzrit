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
    }
    
    /// 모임 리스트 서버에서 읽어오기
    func loadRooms() {
        Task {
            do {
                rooms += try await roomService.loadRoom(isInitial: initialFetch, status: "activation")
                initialFetch = false
                print("로드 완료")
            } catch {
                print("에러: \(error)")
            }
        }
    }
    
    /// 모임에 참여한 유저 정보 읽어오기
    func loadJoinedUsers(roomID : String) async -> [JoinedUserModel] {
        do {
            let joinedUsers = try await roomService.joinedUsers(roomID: roomID)
            print("로드 완료")
            return joinedUsers
        } catch {
            print("에러: \(error)")
            return []
        }
    }
    
    /// 모임 상태 변경시키기
    func changeStatus(roomID: String, status: ActiveType) {
        roomService.changeStatus(roomID: roomID, status: status)
    }
}
