//
//  RecentRoomViewModel.swift
//  ZzritConsumer
//
//  Created by Healthy on 4/22/24.
//

import Foundation

import ZzritKit

@MainActor
class RecentRoomViewModel: ObservableObject {
    @Published var recentViewedRooms: [RoomModel] = []
    
    let roomService: RoomService = RoomService.shared
    private var isRecentRoomInit: Bool = true
    
    init() {
        Task {
            await initalRecentViewedRoomFetch()
        }
    }
    
    func roomInfo(_ roomID: String) async throws -> RoomModel? {
        let room = try await roomService.roomInfo(roomID)
        
        return room
    }
    
    func updateRecentViewedRoom(roomID: String) async {
        // TODO: 나중에 Constant 등으로 키 값 저장하면 좋을듯
        let recentViewdRoomKey = "recentViewedRoom"
        
        // 기존에 저장된 최근 방이 있는 경우
        if var savedRooms = UserDefaults.standard.stringArray(forKey: recentViewdRoomKey) {
            // 중복 저장 방지
            if savedRooms.contains(roomID) {
                return
            }
            
            // 배열의 크기가 5보다 크거나 같으면 마지막 값 삭제
            if savedRooms.count >= 5 {
                savedRooms.removeLast()
            }
            
            savedRooms.insert(roomID, at: 0)
            UserDefaults.standard.set(savedRooms, forKey: recentViewdRoomKey)
            await recentViewedRoomFetch()
        }
        // 기존에 저장된 최근 방이 없는 경우
        else {
            UserDefaults.standard.set([roomID], forKey: recentViewdRoomKey)
            await recentViewedRoomFetch()
        }
    }
    
    /// 최근 본 모임 전체 fetch
    private func initalRecentViewedRoomFetch() async {
        if isRecentRoomInit {
            let recentViewdRoomKey = "recentViewedRoom"
            
            if let roomIDs = UserDefaults.standard.stringArray(forKey: recentViewdRoomKey) {
                for roomID in roomIDs {
                    do {
                        if let room = try await roomInfo(roomID) {
                            recentViewedRooms.append(room)
                            isRecentRoomInit = false
                        }
                    } catch {
                        Configs.printDebugMessage("DEBUG: initalRecentViewedRoomFetch error: \(error)")
                    }
                }
            }
        }
    }
    
    /// 최근 본 모임 일부 fetch
    private func recentViewedRoomFetch() async {
        let recentViewdRoomKey = "recentViewedRoom"
        
        if let roomID = UserDefaults.standard.stringArray(forKey: recentViewdRoomKey)?.first {
            // 5개와 같거나 큰 경우 -> 제일 마지막 값 삭제
            if recentViewedRooms.count >= 5 {
                recentViewedRooms.removeLast()
            }
            
            do {
                if let room = try await roomInfo(roomID) {
                    recentViewedRooms.insert(room, at: 0)
                }
            } catch {
                Configs.printDebugMessage("DEBUG: recentViewedRoomFetch error: \(error)")
            }
        }
    }
}
