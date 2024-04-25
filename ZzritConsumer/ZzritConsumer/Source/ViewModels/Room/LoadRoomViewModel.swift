//
//  LoadRoomViewModel.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/15/24.
//

import Foundation
import CoreLocation

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
    
    func consumerLoadRoom(location: OfflineLocationModel? = LocalStorage.shared.latestSettedLocation()) {
        
        var coordinate: CLLocationCoordinate2D? = nil
        if let location {
            coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        } else {
            coordinate = CLLocationCoordinate2D(
                latitude: OfflineLocationModel.initialLocation.latitude,
                longitude: OfflineLocationModel.initialLocation.longitude
            )
        }
        
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
                
                let newRooms = try await roomService.loadRoom(isInitial: isInit, status: status.rawValue, coordinate: coordinate)
                
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
    
    func getFilter(status: ActiveType = .activation, title: String = "", isOnline: Bool? = nil, category: CategoryType? = nil, date: DateType? = nil) {
//        if prevIsOnline != isOnline {
//            fetchCount = 0
//            Configs.printDebugMessage("카운터 초기화")
//        }
        
        // 필요하다면 기본 날짜 필터 사용
        // filterRooms = rooms.filter { $0.dateTime > Date() }
        
        // 상태 필터
        // filterRooms = filterRooms.filter { $0.status == status }
        filterRooms = rooms.filter { $0.status == status }
        
        // 카테고리 필터
        if let category {
             filterRooms = filterRooms.filter { $0.category == category }
        }
        
        // 날짜 필터
        if let date {
            filterRooms = filterRooms.filter {
                $0.dateTime.toStringYear() == date.date.toStringYear() &&
                $0.dateTime.toStringMonth() == date.date.toStringMonth() &&
                $0.dateTime.toStringDate() == date.date.toStringDate()
            }
        }
        
        // 온/오프라인 필터
        if let isOnline {
            filterRooms = filterRooms.filter { $0.isOnline == isOnline }
        }
        
        // 겹치는 내용이 있다면 집합으로 걸러줌
        filterRooms = Array(Set(filterRooms))
        
        // 제목 필터
        if !title.isEmpty {
            filterRooms = filterRooms.filter { $0.title.contains(title) }
        }
        
        // 늦게 만들어진 순으로 정렬
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
