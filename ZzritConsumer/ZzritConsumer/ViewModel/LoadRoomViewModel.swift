//
//  LoadRoomViewModel.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/15/24.
//

import Foundation

import ZzritKit


class LoadRoomViewModel: ObservableObject {
    let roomService: RoomService = RoomService.shared
    
    // FIXME: rooms private화
    @Published var rooms: [RoomModel] = []
    
    @Published var filterRooms: [RoomModel] = []
    
    @Published var recentViewedRooms: [RoomModel] = []
    
    private var isInit: Bool = true
    private var status: ActiveType = .activation
    private var fetchCount: Int = 0
    private var prevIsOnline: Bool? = nil
    private var isRecentRoomInit: Bool = true
    
    @MainActor
    func consumerLoadRoom(_ title: String = "") {
        Task {
            do {
                if fetchCount < 3 {
                    let newRooms = try await roomService.loadRoom(isInitial: isInit, status: status.rawValue, title: title)
                    
                    if !newRooms.isEmpty {
                        rooms += newRooms
                        fetchCount += 1
                        print("\(fetchCount)회 불러오기")
                    }
                }
                
                isInit = false
            } catch {
                print("\(error)")
            }
        }
    }
    
    func getFilter(status: ActiveType = .activation, category: CategoryType? = nil, isOnline: Bool? = nil) {
        if prevIsOnline != isOnline {
            fetchCount = 0
            print("카운터 초기화")
        }
        
        // FIXME: 리펙토링 필요!
        // 이거 어떻게 해야 쉽게 짤 수 있을까...
        // 뭔가 필터 전용 enum이나 구조체를 만들어서 switch 문이나 filter함수를 간편히 사용할 수 있을 거 같은데...여기까지밖에 안떠오른다.
        if category == nil && isOnline == nil {
            filterRooms = rooms.filter { element in
                return element.status == status
            }
        } else if category != nil && isOnline == nil {
            filterRooms = rooms.filter { element in
                return element.status == status && element.category == category!
            }
        } else if category == nil && isOnline != nil {
            filterRooms = rooms.filter { element in
                return element.status == status && element.isOnline == isOnline!
            }
        } else {
            filterRooms = rooms.filter { element in
                return element.status == status && element.category == category! && element.isOnline == isOnline!
            }
        }
        
        prevIsOnline = isOnline
    }
    
    func roomInfo(_ roomID: String) async throws -> RoomModel {
        let room = try await roomService.roomInfo(roomID)
        
        return room
    }
    
    /// 최근 본 모임 전체 fetch
    func initalRecentViewedRoomFetch() async {
        if isRecentRoomInit {
            let recentViewdRoomKey = "recentViewedRoom"
            
            if let roomIDs = UserDefaults.standard.stringArray(forKey: recentViewdRoomKey) {
                for roomID in roomIDs {
                    do {
                        try await recentViewedRooms.append(roomInfo(roomID))
                        isRecentRoomInit = false
                    } catch {
                        print("DEBUG: initalRecentViewedRoomFetch error: \(error)")
                    }
                }
            }
        }
    }
    
    /// 최근 본 모임 일부 fetch
    func recentViewedRoomFetch() async {
        let recentViewdRoomKey = "recentViewedRoom"
        
        if let roomID = UserDefaults.standard.stringArray(forKey: recentViewdRoomKey)?.last {
            // 5개가 넘는 경우 -> 제일 처음꺼 삭제
            if recentViewedRooms.count >= 5 {
                recentViewedRooms.removeFirst()
            }
            
            do {
                try await recentViewedRooms.append(roomInfo(roomID))
            } catch {
                print("DEBUG: recentViewedRoomFetch error: \(error)")
            }
        }
    }
}
