//
//  SearchViewModel.swift
//  ZzritConsumer
//
//  Created by SunJoon Lee on 4/23/24.
//

import SwiftUI

import ZzritKit

final class SearchViewModel: ObservableObject {
    let roomService: RoomService = RoomService.shared
    
    private var rooms: [RoomModel] = []
    @Published var filterRooms: [RoomModel] = []
    
    private var isInit: Bool = true
    private let status: ActiveType = .activation
    
    @MainActor
    func loadRoom(_ title: String = "") {
        Task {
            do {
                let newRooms = try await roomService.loadRoom(isInitial: isInit, status: status.rawValue, title: title)
                
                if !newRooms.isEmpty {
                    rooms += newRooms
                }
                isInit = false
            } catch {
                print("\(error)")
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
    
    func getFilter(_ filterModel: FilterModel) {
        
        // 기본 날짜 필터
        filterRooms = rooms.filter { $0.dateTime > Date() }
        
        // 날짜 필터
        if let selectedDate = filterModel.dateSelection {
            filterRooms = filterRooms.filter {
                $0.dateTime.toStringYear() == selectedDate.date.toStringYear() &&
                $0.dateTime.toStringMonth() == selectedDate.date.toStringMonth() &&
                $0.dateTime.toStringDate() == selectedDate.date.toStringDate()
            }
        }
        
        // 카테고리 필터
        if let category = filterModel.categorySelection {
            filterRooms = filterRooms.filter { $0.category == category }
        }
        
        // 온/오프라인 필터
        if let isOnline = filterModel.isOnline {
            filterRooms = filterRooms.filter { $0.isOnline == isOnline }
        }
        
        // 제목 필터
        if !filterModel.searchText.isEmpty {
            filterRooms = filterRooms.filter { $0.title.contains(filterModel.searchText) }
        }
    }
    
    func roomInfo(_ roomID: String) async throws -> RoomModel? {
        let room = try await roomService.roomInfo(roomID)
        return room
    }
}
