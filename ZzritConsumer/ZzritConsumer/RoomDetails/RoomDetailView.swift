//
//  RoomDetailView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/9/24.
//

import SwiftUI

import ZzritKit

struct RoomDetailView: View {
    @EnvironmentObject private var userService: UserService
    
    let room: RoomModel
    let roomService = RoomService.shared
    // 참석 버튼 눌렀는 지 확인
    @State private var isParticipant: Bool = false
    
    @State private var alertToLogin: Bool = false
    
    @State private var isShowingLoginView: Bool = false
    
    @State private var isJoined: Bool = false
    
    @State private var participants: [JoinedUserModel] = []
    
    @State private var participantsCount: Int = 0
    // 유저모델 변수
    @State private var userModel: UserModel?
    
    private var isLogined: Bool {
        return userModel != nil
    }
    
    // MARK: - body
    
    var body: some View {
        
        //MARK: - iOS17
        
        if #available(iOS 17.0, *) {
            ZStack(alignment: .bottom) {
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        // 상단 타이틀 Stack
                        HStack {
                            // 카테고리
                            RoomCategoryView(room.category.rawValue)
                            
                            // 타이틀
                            Text(room.title)
                                .font(.title3)
                        }
                        
                        // 썸네일 이미지
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.clear)
                            .aspectRatio(contentMode: .fill)
                            .frame(maxHeight: 200)
                            .background {
                                AsyncImage(url: room.roomImage) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxHeight: 200)
                                        .clipShape(RoundedRectangle(cornerRadius: Configs.cornerRadius))
                                    
                                } placeholder: {
                                    ProgressView()
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                            }
                            .padding(.bottom, 20)
                        
                        // 세부 내용
                        Text(room.content)
                            .foregroundStyle(Color.staticGray1)
                            .padding(.bottom, 40)
                        
                        // 위치, 시간, 참여 인원에 대한 정보를 나타내는 뷰
                        RoomInfoView(room: room, participantsCount: participantsCount)
                            .padding(.bottom, 40)
                        
                        Text("와우, 벌써 \(participantsCount)명이나 모였어요.")
                            .font(.title3)
                            .fontWeight(.bold)
                        // 참여자의 정보를 나타내는 뷰
                        ParticipantListView(room: room, participants: participants)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 1)
                .padding(.bottom, 85)
                
                participateRoomButton
            }
            .toolbarRole(.editor)
            .onAppear {
                Task {
                    do {
                        userModel = try await userService.loginedUserInfo()
                        if let roomId = room.id {
                            participants = try await roomService.joinedUsers(roomID: roomId)
                        }
                        participantsCount = participants.count
                    } catch {
                        print("\(error)")
                    }
                }
            }
            .onChange(of: isLogined) {
                if isLogined  {
                    Task {
                        do {
                            if let roomId = room.id, let userModel = userModel?.id {
                                isJoined = try await roomService.isJoined(roomID: roomId, userUID: userModel)
                            }
                        } catch {
                            print("참여한 방인지 여부의 error: \(error)")
                        }
                    }
                }
            }
            
        //MARK: - iOS16
            
        } else {
            ZStack(alignment: .bottom) {
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        // 상단 타이틀 Stack
                        HStack {
                            // 카테고리
                            RoomCategoryView(room.category.rawValue)
                            
                            // 타이틀
                            Text(room.title)
                                .font(.title3)
                        }
                        
                        // 썸네일 이미지
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.clear)
                            .aspectRatio(contentMode: .fill)
                            .frame(maxHeight: 200)
                            .background {
                                AsyncImage(url: room.roomImage) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxHeight: 200)
                                        .clipShape(RoundedRectangle(cornerRadius: Configs.cornerRadius))
                                    
                                } placeholder: {
                                    ProgressView()
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                            }
                            .padding(.bottom, 20)
                        
                        // 세부 내용
                        Text(room.content)
                            .foregroundStyle(Color.staticGray1)
                            .padding(.bottom, 40)
                        
                        // 위치, 시간, 참여 인원에 대한 정보를 나타내는 뷰
                        RoomInfoView(room: room, participantsCount: participantsCount)
                            .padding(.bottom, 40)
                        
                        Text("와우, 벌써 \(participantsCount)명이나 모였어요.")
                            .font(.title3)
                            .fontWeight(.bold)
                        // 참여자의 정보를 나타내는 뷰
                        ParticipantListView(room: room, participants: participants)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 1)
                .padding(.bottom, 85)
                
                participateRoomButton
            }
            .toolbarRole(.editor)
            .onAppear {
                Task {
                    do {
                        userModel = try await userService.loginedUserInfo()
                        if let roomId = room.id {
                            participants = try await roomService.joinedUsers(roomID: roomId)
                        }
                        participantsCount = participants.count
                    } catch {
                        print("\(error)")
                    }
                }
            }
            .onChange(of: isLogined) { newValue in
                if isLogined  {
                    Task {
                        do {
                            if let roomId = room.id, let userModel = userModel?.id {
                                isJoined = try await roomService.isJoined(roomID: roomId, userUID: userModel)
                            }
                        } catch {
                            print("참여한 방인지 여부의 error: \(error)")
                        }
                    }
                }
            }
        }
    }
}

extension RoomDetailView {
    private var participateRoomButton: some View {
        VStack {
            GeneralButton(isJoined ? "이미 참여한 방 입니다" : "참여하기", isDisabled: isJoined) {
                if isLogined {
                    isParticipant.toggle()
                } else {
                    alertToLogin.toggle()
                }
            }
            .padding(20)
            .navigationDestination(isPresented: $isParticipant) {
                ParticipantNoticeView(room: room)
            }
            .alert("로그인 알림", isPresented: $alertToLogin) {
                // 로그인 시트 올리는 버튼
                Button {
                    isShowingLoginView.toggle()
                } label: {
                    Label("로그인", systemImage: "person.circle")
                        .labelStyle(.titleOnly)
                }
                // 취소 버튼
                Button{
                    alertToLogin = false
                } label: {
                    Label("취소", systemImage: "trash")
                        .labelStyle(.titleOnly)
                }
            } message: {
                Text("모임에 참가하기 위해서는 로그인이 필요합니다.")
            }
            .fullScreenCover(isPresented: $isShowingLoginView) {
                LogInView()
            }
        }
    }
}

#Preview {
    RoomDetailView( room: RoomModel(title: "같이 모여서 가볍게 치맥하실 분...", category: .hobby, dateTime: Date(), content: "test", coverImage: "https://picsum.photos/200", isOnline: false, status: .activation, leaderID: "", limitPeople: 8))
        .environmentObject(UserService())
}
