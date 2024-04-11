//
//  RoomView.swift
//  ZzritModelTest
//
//  Created by Sanghyeon Park on 4/10/24.
//

import SwiftUI

import ZzritKit

struct RoomView: View {
    private let roomService = RoomService.shared
    
    @State private var rooms: [RoomModel] = []
    
    @State private var toggle: Bool = true
    
    var body: some View {
        NavigationStack {
            List(rooms) { room in
                VStack {
                    Text(room.title)
                    Text(room.id!)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                Button("모임 참여") {
                    joinRoom(roomID: room.id!)
                }
                Button("모임 탈퇴") {
                    leaveRoom(roomID: room.id!)
                }
                Button("활성화") {
                    roomService.changeStatus(roomID: room.id!, status: .activation)
                }
                Button("비활성화") {
                    roomService.changeStatus(roomID: room.id!, status: .deactivation)
                }
                Button("삭제") {
                    roomService.changeStatus(roomID: room.id!, status: .delete)
                }
            }
            .onAppear {
                fetchRooms()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("추가") {
                        
                    }
                }
            }
        }
    }
    
    //    private func createRoom() {
    //        do {
    //
    //        } catch {
    //            print("에러: \(error)")
    //        }
    //    }
    
    private func fetchRooms() {
        Task {
            do {
                rooms = try await roomService.loadRoom(isInitial: true)
                print("로드 완료")
            } catch {
                print("에러: \(error)")
            }
        }
    }
    
    private func joinRoom(roomID: String) {
        Task {
            do {
                try await roomService.joinRoom(roomID)
                print("모임참여 완료")
            } catch {
                print("에러: \(error)")
            }
        }
    }
    
    private func leaveRoom(roomID: String) {
        Task {
            do {
                try await roomService.leaveRoom(roomID: roomID)
                print("모임탈퇴 완료")
            } catch {
                print("에러: \(error)")
            }
        }
    }
}

#Preview {
    NavigationStack {
        RoomView()
    }
}
