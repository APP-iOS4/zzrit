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
    
    var body: some View {
        NavigationStack {
            List(rooms) { room in
                HStack {
                    Text(room.title)
                }
                Button("모임 참여") {
                    joinRoom(roomID: room.id!)
                }
                Button("모임 탈퇴") {
                    leaveRoom(roomID: room.id!)
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
