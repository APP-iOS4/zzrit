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
    @EnvironmentObject private var recentRoomViewModel: RecentRoomViewModel
    
    @Binding var offlineLocation: OfflineLocationModel?
    
    @State var room: RoomModel
    let roomService = RoomService.shared
    // 참석 버튼 눌렀는 지 확인
    @State private var isParticipant: Bool = false
    
    @State private var alertToLogin: Bool = false
    
    @State private var isShowingLoginView: Bool = false
    
    @State private var alertToReport: Bool = false
    
    @State private var isShowingContactInputView: Bool = false
    
    @State private var isJoined: Bool = false
    
    @State private var confirmParticipation: Bool = false
    
    @State private var isActive: Bool = true
    
    @State private var participants: [JoinedUserModel] = []
    
    @State private var participantsCount: Int = 0
    // 유저모델 변수
    @State private var userModel: UserModel?
    
    private var confirmDate: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: room.dateTime) ?? Date()
    }
    
    private var isDeactivation: Bool {
        return confirmDate < Date()
    }
    
    private var isLogined: Bool {
        return userModel != nil
    }
    
    private var overParticipants: Bool {
        return room.limitPeople <= participantsCount
    }
    
    private var overStartTime: Bool {
        return room.dateTime < Date()
    }
    
    private var passGenderLimitation: Bool {
        if let genderLimitation = room.genderLimitation, let userModel {
            if userModel.gender == genderLimitation {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    private var passScoreLimitation: Bool {
        if let scoreLimitation = room.scoreLimitation, let userModel {
            if Int(userModel.staticGauge) >= scoreLimitation {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    // 모임 이미지
    @State private var roomImage: UIImage?
    
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
                                fetchRoomImage(image: roomImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxHeight: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: Configs.cornerRadius))
                            }
                            .padding(.bottom, 20)
                        
                        // 세부 내용
                        Text(room.content)
                            .foregroundStyle(Color.staticGray1)
                            .padding(.bottom, 40)
                        
                        // 위치, 시간, 참여 인원에 대한 정보를 나타내는 뷰
                        RoomInfoView(room: room, participantsCount: participantsCount, offlineLocation: $offlineLocation)
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
            .toolbar {
                if isLogined {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            alertToReport.toggle()
                        } label: {
                            Image(systemName: "light.beacon.max")
                        }
                    }
                }
            }
            .alert("신고하기", isPresented: $alertToReport) {
                Button{
                    alertToReport = false
                } label: {
                    Label("취소", systemImage: "trash")
                        .labelStyle(.titleOnly)
                }
                
                Button {
                    isShowingContactInputView.toggle()
                } label: {
                    Label("신고하기", systemImage: "person.circle")
                        .labelStyle(.titleOnly)
                }
            } message: {
                Text("해당 모임을 신고하시겠습니까?")
            }
            .navigationDestination(isPresented: $isShowingContactInputView, destination: {
                if let roomid = room.id {
                    ContactInputView(selectedContactCategory: .room, selectedRoomContact: roomid, selectedUserContact: "", contactThroughRoomView: true)
                }
            })
            .onAppear {
                modifyRoomStatus()
                Task {
                    do {
                        await updateRecentRoom()
                        userModel = try await userService.loggedInUserInfo()
                        if let roomId = room.id {
                            participants = try await roomService.joinedUsers(roomID: roomId)
                        }
                        participantsCount = participants.count
                        // 모임방 사진 가져오기
                        if room.coverImage != "NONE" {
                            roomImage = await ImageCacheManager.shared.findImageFromCache(imagePath: room.coverImage)
                        }
                    } catch {
                        Configs.printDebugMessage("\(error)")
                    }
                }
            }
            .customOnChange(of: isShowingLoginView) { _ in
                Task {
                    do {
                        userModel = try await userService.loggedInUserInfo()
                    } catch {
                        Configs.printDebugMessage("참여한 방인지 여부의 error: \(error)")
                    }
                }
            }
        }
    }
    
    func updateRecentRoom() async {
        if let roomID = room.id {
            await recentRoomViewModel.updateRecentViewedRoom(roomID: roomID)
        }
    }
    
    func modifyRoomStatus() {
        if isDeactivation {
            if let roomID = room.id {
                roomService.changeStatus(roomID: roomID, status: .deactivation)
            }
        }
    }
    
    // 이미지 적용
    func fetchRoomImage(image: UIImage?) -> Image {
        if let image = image {
            Image(uiImage: image)
        } else {
            // 이미지가 없거나 로드에 실패했을때
            Image("ZziritLogoImage")
        }
    }
}

extension RoomDetailView {
    private var participateRoomButton: some View {
        VStack {
            if isJoined {
                Text("이미 참여한 방 입니다")
                    .modifier(disableTextModifier())
            } else if overParticipants {
                Text("인원이 가득 찼습니다")
                    .modifier(disableTextModifier())
            } else if overStartTime {
                Text("모임 시작 시간이 지났습니다")
                    .modifier(disableTextModifier())
            } else {
                if room.genderLimitation != nil {
                    if !passGenderLimitation {
                        Text("참여 하실 수 없습니다(성별 제한)")
                            .modifier(disableTextModifier())
                    }
                } else if room.scoreLimitation != nil {
                    if !passScoreLimitation {
                        Text("참여 하실 수 없습니다(점수 제한)")
                            .modifier(disableTextModifier())
                    }
                } else {
                    GeneralButton("참여하기", isDisabled: false) {
                        if isLogined {
                            isParticipant.toggle()
                        } else {
                            alertToLogin.toggle()
                        }
                    }
                    .navigationDestination(isPresented: $confirmParticipation) {
                        if let roomID = room.id {
                            ChatView(roomID: roomID, room: room, isActive: $isActive, offlineLocation: $offlineLocation)
                        }
                    }
                    .alert("로그인 알림", isPresented: $alertToLogin) {
                        // 취소 버튼
                        Button{
                            alertToLogin = false
                        } label: {
                            Label("취소", systemImage: "trash")
                                .labelStyle(.titleOnly)
                        }
                        // 로그인 시트 올리는 버튼
                        Button {
                            isShowingLoginView.toggle()
                        } label: {
                            Label("로그인", systemImage: "person.circle")
                                .labelStyle(.titleOnly)
                        }
                    } message: {
                        Text("모임에 참가하기 위해서는 로그인이 필요합니다.")
                    }
                    .fullScreenCover(isPresented: $isParticipant) {
                        ParticipantNoticeView(room: room, confirmParticipation: $confirmParticipation)
                    }
                    .fullScreenCover(isPresented: $isShowingLoginView) {
                        LogInView()
                    }
                }
            }
        }
        .padding(20)
        .customOnChange(of: isLogined) { _ in
            Task {
                do {
                    if isLogined {
                        if let roomId = room.id, let userModel = userModel?.id {
                            isJoined = try await roomService.isJoined(roomID: roomId, userUID: userModel)
                        }
                    }
                } catch {
                    Configs.printDebugMessage("참여한 방인지 여부의 error: \(error)")
                }
            }
        }
    }
}

struct disableTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.black)
            .fontWeight(.semibold)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.staticGray5)
            .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    NavigationStack {
        RoomDetailView(offlineLocation: .constant(nil), room: RoomModel(title: "같이 모여서 가볍게 치맥하실 분...", category: .hobby, dateTime: Date(), content: "test", coverImage: "https://picsum.photos/200", isOnline: false, status: .activation, leaderID: "", limitPeople: 8))
            .environmentObject(UserService())
            .environmentObject(RecentRoomViewModel())
    }
}
