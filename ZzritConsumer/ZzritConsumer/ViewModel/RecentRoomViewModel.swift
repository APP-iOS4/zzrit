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
            
            // 5개가 넘는 경우 -> 제일 처음꺼 삭제
            if savedRooms.count >= 5 {
                savedRooms.removeFirst()
            }
            
            savedRooms.append(roomID)
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
                        print("DEBUG: initalRecentViewedRoomFetch error: \(error)")
                    }
                }
            }
        }
    }
    
    /// 최근 본 모임 일부 fetch
    private func recentViewedRoomFetch() async {
        let recentViewdRoomKey = "recentViewedRoom"
        
        if let roomID = UserDefaults.standard.stringArray(forKey: recentViewdRoomKey)?.last {
            // 5개가 넘는 경우 -> 제일 처음꺼 삭제
            if recentViewedRooms.count >= 5 {
                recentViewedRooms.removeFirst()
            }
            
            do {
                if let room = try await roomInfo(roomID) {
                    recentViewedRooms.append(room)
                }
            } catch {
                print("DEBUG: recentViewedRoomFetch error: \(error)")
            }
        }
    }
}
