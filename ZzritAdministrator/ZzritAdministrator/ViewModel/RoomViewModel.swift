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
        loadDeactivateRooms()
    }
    
    /// 모임 리스트 서버에서 읽어오기
    func loadRooms() {
        Task {
            do {
                rooms += try await roomService.loadRoom(isInitial: initialFetch, status: ActiveType.activation.rawValue)
                initialFetch = false
                print("로드 완료")
            } catch {
                print("에러: \(error)")
            }
        }
    }
    
    /// 모임 리스트 서버에서 읽어오기
    func loadDeactivateRooms() {
        Task {
            do {
                rooms += try await roomService.loadRoom(isInitial: initialFetch, status: ActiveType.deactivation.rawValue)
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
        
        // 앱(로컬) 데이터 수정
        if let index = rooms.firstIndex(where: { $0.id == roomID }) {
            rooms[index].status = status
        }
    }
}
