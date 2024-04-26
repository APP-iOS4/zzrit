//
//  SearchViewModel.swift
//  ZzritConsumer
//
//  Created by SunJoon Lee on 4/23/24.
//

// 메인 <-> 탐색 (제목, 카테, 날짜


import SwiftUI
import CoreLocation

import ZzritKit

@MainActor
final class SearchViewModel: ObservableObject {
    let roomService: RoomService = RoomService.shared
    
    @Published private(set) var rooms: [RoomModel] = []
    @Published private(set) var filterRooms: [RoomModel] = []
    
    private var isInit: Bool = true
    private var status: ActiveType = .activation
    
    init() {
        loadRooms()
    }
    
    func loadRooms(filterModel: FilterModel = FilterModel(), offlineLocation: OfflineLocationModel? = nil) {
        
        var coordinate: CLLocationCoordinate2D? = nil
        
        if filterModel.isOnline == false {
            if let offlineLocation {
                coordinate = CLLocationCoordinate2D(latitude: offlineLocation.latitude, longitude: offlineLocation.longitude)
            } else {
                coordinate = CLLocationCoordinate2D(
                    latitude: OfflineLocationModel.initialLocation.latitude,
                    longitude: OfflineLocationModel.initialLocation.longitude
                )
            }
        }
        
        Task {
            do {
                let newRooms = try await roomService.searchLoadRoom(isInitial: isInit, status: status.rawValue, isOnline: filterModel.isOnline, coordinate: coordinate)
                
                if !newRooms.isEmpty {
                    rooms += newRooms
                    rooms = Array(Set(rooms))
                }
                
                if isInit {
                    getFilter(with: filterModel)
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
    
    func getFilter(status: ActiveType = .activation, with filterModel: FilterModel) {
        // 상태 필터
        // filterRooms = filterRooms.filter { $0.status == status }
        filterRooms = rooms.filter { $0.status == status }
        
        // 카테고리 필터
        if let category = filterModel.category {
             filterRooms = filterRooms.filter { $0.category == category }
        }
        
        // 날짜 필터
        if let dateType = filterModel.dateType {
            filterRooms = filterRooms.filter {
                $0.dateTime.toStringYear() == dateType.date.toStringYear() &&
                $0.dateTime.toStringMonth() == dateType.date.toStringMonth() &&
                $0.dateTime.toStringDate() == dateType.date.toStringDate()
            }
        }
        
        // 겹치는 내용이 있다면 집합으로 걸러줌
        filterRooms = Array(Set(filterRooms))
        
        // 제목 필터
        if !filterModel.title.isEmpty {
            filterRooms = filterRooms.filter { $0.title.contains(filterModel.title) }
        }
        
        // 늦게 만들어진 순으로 정렬
        filterRooms.sort(by: { $0.createTime > $1.createTime })
    }
    
    func roomInfo(_ roomID: String) async throws -> RoomModel? {
        let room = try await roomService.roomInfo(roomID)
        return room
    }
    
    func refreshRooms(with filterModel: FilterModel, offlineLocation: OfflineLocationModel? = nil) {
        // fetchCount = 0
        isInit = true
        rooms = []
        loadRooms(filterModel: filterModel, offlineLocation: offlineLocation)
    }
}
