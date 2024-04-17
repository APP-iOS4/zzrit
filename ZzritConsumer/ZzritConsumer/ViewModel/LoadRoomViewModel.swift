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
    
    private var isInit: Bool = true
    private var status: ActiveType = .activation
    
    @MainActor
    func consumerLoadRoom() async throws {
        do {
            rooms += try await roomService.loadRoom(isInitial: isInit, status: status.rawValue)
            isInit = false
        } catch {
            print("\(error)")
        }
    }
    
    func getFilter(status: ActiveType = .activation, category: CategoryType? = nil, isOnline: Bool? = nil) {
        // FIXME: 현재 필터링 기능 작동 안함
        // 이거 어떻게 해야 쉽게 짤 수 있을까.......
        // 뭔가 필터 전용 enum이나 구조체를 만들어서 switch 문이나 filter함수를 간편히 사용할 수 있을 거 같은데...여기까지밖에 안떠오른다....
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
    }
}
