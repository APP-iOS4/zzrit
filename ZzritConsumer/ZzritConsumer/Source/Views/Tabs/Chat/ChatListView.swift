//
//  ChatListView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/10/24.
//

import SwiftUI

import ZzritKit

struct ChatListView: View {
    @EnvironmentObject private var userService: UserService
    
    @State private var selection = "참여 중인 모임"
    @State private var userModel: UserModel?
    @State private var rooms: [RoomModel] = []
    @State private var checkActivation: Bool = false
    
    private let loadRoomViewModel: LoadRoomViewModel = LoadRoomViewModel()
    
    private var isLogined: Bool {
        return userModel != nil
    }
    
    //MARK: - body
    
    var body: some View {
        if #available(iOS 17.0, *) {
            NavigationStack {
                VStack {
                    ChatCategoryView(selection: $selection)
                    // FIXME: 현재 뷰가 Active뷰, Deactive뷰 따로 있지만 모델 연동 시, 하나의 뷰로 이용할 것, 지금은 더미로 뷰를 두 개 생성
                    if isLogined {
                        // TODO: 가장 최근에 메시지가 온 모임이 상단에 뜨도록 정렬
                        if selection == "참여 중인 모임" {
                            ChatActiveListView(rooms: rooms)
                        } else {
                            ChatDeactiveListView(rooms: rooms)
                        }
                    }
                    Spacer()
                }
                .toolbar {
                    // 왼쪽 어디 탭인지 알려주는 제목
                    ToolbarItem(placement: .topBarLeading) {
                        HStack(spacing: 0) {
                            Text("채팅")
                        }
                        .font(.title3)
                        .fontWeight(.black)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
            }
            .onAppear {
                Task {
                    do {
                        try await isLogined()
                        try await fetchRoom()
                        
                        checkActivation = true
                    } catch {
                        print("에러 \(error)")
                    }
                }
            }
            .onChange(of: checkActivation) {
                deactivateRooms()
            }
            
        // MARK: - iOS 16
            
        } else {
            NavigationStack {
                VStack {
                    ChatCategoryView(selection: $selection)
                    // FIXME: 현재 뷰가 Active뷰, Deactive뷰 따로 있지만 모델 연동 시, 하나의 뷰로 이용할 것, 지금은 더미로 뷰를 두 개 생성
                    if isLogined {
                        // TODO: 가장 최근에 메시지가 온 모임이 상단에 뜨도록 정렬
                        if selection == "참여 중인 모임" {
                            ChatActiveListView(rooms: rooms)
                        } else {
                            ChatDeactiveListView(rooms: rooms)
                        }
                    }
                    Spacer()
                }
                .toolbar {
                    // 왼쪽 어디 탭인지 알려주는 제목
                    ToolbarItem(placement: .topBarLeading) {
                        HStack(spacing: 0) {
                            Text("채팅")
                        }
                        .font(.title3)
                        .fontWeight(.black)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
            }
            .onAppear {
                Task {
                    do {
                        try await isLogined()
                        try await fetchRoom()
                        
                        checkActivation = true
                    } catch {
                        print("에러 \(error)")
                    }
                }
            }
            .onChange(of: checkActivation) { newValue in
                deactivateRooms()
            }
        }
    }
    
    func isLogined() async throws {
        userModel = try await userService.loginedUserInfo()
    }
    
    func fetchRoom() async throws {
        rooms.removeAll()
        if let userModel {
            if let joinedRooms = userModel.joinedRooms {
                for roomID in joinedRooms {
                    if let room = try await loadRoomViewModel.roomInfo(roomID) {
                        rooms.append(room)
                    }
                }
            } else {
                print("방을 참여해주세요")
            }
        } else {
            print("로그인을 해주세요.")
        }
    }
    
    func deactivateRooms() {
        var tempRooms: [RoomModel] = []
        
        for room in rooms {
            let tempRoom = loadRoomViewModel.deactivateOneRoom(room: room)
            
            tempRooms.append(tempRoom)
        }
        
        rooms = tempRooms
    }
}

#Preview {
    NavigationStack {
        ChatListView()
            .environmentObject(UserService())
    }
}
