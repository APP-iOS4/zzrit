//
//  LoadRoomViewModel.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/15/24.
//

import Foundation

import ZzritKit

@MainActor
class LoadRoomViewModel: ObservableObject {
    let roomService: RoomService = RoomService.shared
    
    @Published private(set) var rooms: [RoomModel] = []
    
    @Published private(set) var filterRooms: [RoomModel] = []
    
    private var isInit: Bool = true
    private var status: ActiveType = .activation
    // private var fetchCount: Int = 0
    // private var prevIsOnline: Bool? = nil
    
    init() {
        consumerLoadRoom()
    }
    
    func consumerLoadRoom(_ title: String = "") {
        Task {
            do {
                /*
                 if fetchCount < 3 {
                 let newRooms = try await roomService.loadRoom(isInitial: isInit, status: status.rawValue, title: title)
                 
                 if !newRooms.isEmpty {
                 rooms += newRooms
                 fetchCount += 1
                 Configs.printDebugMessage("\(fetchCount)회 불러오기")
                 }
                 }
                 */
                
                let newRooms = try await roomService.loadRoom(isInitial: isInit, status: status.rawValue, title: title)
                
                if !newRooms.isEmpty {
                    rooms += newRooms
                    rooms = Array(Set(rooms))
                }
                
                if isInit {
                    getFilter(isOnline: false)
                }
    
                isInit = false
            } catch {
                Configs.printDebugMessage("\(error)")
            }
        }
    }
    
    func deactivateRooms() {
        var tempRooms: [RoomModel] = []
        
        for room in rooms {
            let tempRoom = deactivateOneRoom(room: room)
            
            tempRooms.append(tempRoom)
        }
        
        rooms = tempRooms
    }
    
    func deactivateOneRoom(room: RoomModel) -> RoomModel{
        var tempRoom: RoomModel = room
        let confirmDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: tempRoom.dateTime) ?? Date()
        
        if confirmDate < Date() {
            tempRoom.status = .deactivation
            if let roomID = tempRoom.id {
                roomService.changeStatus(roomID: roomID, status: .deactivation)
            }
        }
        
        return tempRoom
    }
    
    func getFilter(status: ActiveType = .activation, category: CategoryType? = nil, isOnline: Bool? = nil) {
//        if prevIsOnline != isOnline {
//            fetchCount = 0
//            Configs.printDebugMessage("카운터 초기화")
//        }
        
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
        
        filterRooms = Array(Set(filterRooms))
        filterRooms.sort(by: { $0.createTime > $1.createTime })
        
        // prevIsOnline = isOnline
    }
    
    func roomInfo(_ roomID: String) async throws -> RoomModel? {
        let room = try await roomService.roomInfo(roomID)
        return room
    }
    
    func refreshRooms() {
        // fetchCount = 0
        isInit = true
        rooms = []
        consumerLoadRoom()
    }
}
