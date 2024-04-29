//
//  ChatView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/11/24.
//

import SwiftUI

import ZzritKit

struct ChatView: View {
    // 채팅 서비스 불러옴
    @StateObject private var chattingService: ChattingService
    // 채팅 나가기 했을때
    @Environment(\.dismiss) private var dismiss
    // 모임 정보
    let room: RoomModel
    // 모임방 활성화 여부
    @Binding var isActive: Bool
    
    // 유저 정보 불러옴
    @EnvironmentObject private var userService: UserService
    // 방 상태 불러옴
    @EnvironmentObject private var loadRoomViewModel: LoadRoomViewModel
    // 채팅방 N 표시
    @EnvironmentObject private var lastChatModel: LastChatModel
    // 유저모델 변수
    @State private var userModel: UserModel?
    
    // FIXME: 현재 계정의 uid로 바꾸어 주기
    @State private var uid = ""
    
    // 모임방 나가기 기능을 위한 것
    private let roomService = RoomService.shared
    
    // 채팅의 이미지 저장을 위한 것
    let storageService = StorageService()
    
    // 입력 메세지 변수
    @State private var messageText: String = ""
    
    // 메시지 모델
    var messages: [ChattingModel] {
        chattingService.messages
    }
    // 정렬된 메시지 저장할 곳
    @State private var sortedChat: [Int: [ChattingModel]]?
    @State private var sortedDay = [0]
    
    // 메시지를 보냈을 때
    @State private var isSending = false
    
    // 불러올 채팅이 없음을 판별
    @State private var isfetchFinish = false
    @State private var isFirstEnter = true
    
    // 새로 로딩됨을 판별
    // 새 메시지가 왔을 때
    @State private var isLoadNew = false
    // (내가) 이미지를 보냈을때
    @State private var isSendImage = false
    // 채팅로드했을때 위치 조정을 위한 아이디 저장 변수
    @State private var loadingNewID: String?
    @State private var loadingMiddleID: String?
    
    // 이미지 전송용
    @State private var isShowingImagePicker: Bool = false
    @State private var isRealSendSheet: Bool = false
    
    @State private var selectedUIImage: UIImage?
    @State private var image: Image?
    
    // 사진 크게 보기 View
    @State private var isImageDetail = false
    @State private var showImageDetail: UIImage?
    
    // 스크롤뷰용
    // 스크롤뷰의 맨밑 담당
    @Namespace private var bottomID
    // 스크롤뷰의 중간 담당
    @Namespace private var middleID
    // 스크롤뷰 맨 위로 올렸을때
    @State private var prevValue: Double = 0
    
    // 모임 상세보기 시트
    @State private var isRoomDetailShow = false
    // 모임 나가기 알럿
    @State private var isGoOutRoomAlert = false
    // 신고하기 시트
    @State private var isContactShow = false
    
    private var confirmDate: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: room.dateTime) ?? Date()
    }
    
    private var isDeactivation: Bool {
        return confirmDate < Date()
    }
    
    // 모임 정보 init
    init(roomID: String, room: RoomModel, isActive: Binding<Bool>) {
        self._chattingService = StateObject(wrappedValue: ChattingService(roomID: roomID))
        self.room = room
        self._isActive = isActive
    }
    
    var body: some View {
        // ChatRoomNoticeView 에 색을 줬을때 맨위 safeArea까지 색 변경 안되도록 막아주는 경계
        Rectangle()
            .frame(maxWidth: .infinity)
            .frame(height: 1)
            .foregroundStyle(.clear)
        
        VStack(spacing: 0) {
            // 채팅 상단의 모임 간단 정보
            ChatRoomNoticeView(room: room)
                .background(Color.lightPointColor)
            
            ScrollViewWithOffset(onScroll: scrollEvent) {
                ScrollViewReader { proxy in
                    LazyVStack {
                        // 더 이상 로드할 채팅이 없음을 알림
                        HStack {
                            if isfetchFinish {
                                Text("- 대화내용의 끝입니다. -")
                                    .foregroundStyle(Color.staticGray1)
                                    .padding(.top, 10)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        ForEach(sortedDay, id: \.self) { day in
                            // 바뀐 날짜 표시
                            VStack {
                                Text(" ")
                                Text(toStringChatDay(chat: sortedChat?[day]!.first ?? ChattingModel(userID: "실패", message: "실패", type: .text)))
                                    .font(.caption)
                                    .foregroundStyle(Color.staticGray3)
                                    .frame(maxWidth: .infinity)
                            }
                            //                            .padding(.bottom, 5)
                            
                            // 메시지
                            if let sortedChat = sortedChat?[day]! {
                                ForEach(sortedChat) { chat in
                                    // 중간 스크롤 위치 저장용
                                    if chat.id == loadingMiddleID {
                                        Rectangle()
                                            .id(middleID)
                                            .frame(maxWidth: .infinity)
                                            .foregroundStyle(.clear)
                                    }
                                    chatView(chat: chat)
                                        .padding(.vertical, 2)
                                }
                                .onAppear {
                                    // 처음 들어갔을때 가장 최근 메시지부터 보이도록
                                    if isFirstEnter {
                                        proxy.scrollTo(bottomID, anchor: .bottom)
                                    }
                                }
                            }
                        }
                        
                        VStack {
                            // 내가 이미지 보냈을때 (보내기 + 받기) 시간이 너무 오래걸려서 중간에 보여주는 FakeView
                            if isSendImage {
                                HStack(alignment: .top) {
                                    HStack(alignment: .bottom) {
                                        Spacer()
                                        Text("전송 중...")
                                            .font(.caption2)
                                            .foregroundStyle(Color.staticGray2)
                                        ProgressView()
                                            .frame(width: 100, height: 100)
                                            .onAppear {
                                                proxy.scrollTo(bottomID, anchor: .bottom)
                                            }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    
                    //스크롤 뷰의 맨밑 자리 담당
                    if #available(iOS 17.0, *) {
                        Rectangle()
                            .id(bottomID)
                            .frame(height: 5)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.clear)
                            .onChange(of: messages.count) {
                                // 고치면 else문에도 고쳐주기
                                if isSendImage {
                                    // 내가 보낸 사진임을 깨닫고, 다시 닫음
                                    isSendImage.toggle()
                                }
                                sortedChat = sortChat(chat: messages)
                                sortedDay = sortedChat!.keys.sorted(by: { prev, next in
                                    return prev < next
                                })
                                if isSending {
                                    // 내가 보냈을때
                                    proxy.scrollTo(bottomID, anchor: .bottom)
                                    isSending.toggle()
                                } else {
                                    if isLoadNew == true {
                                        // 과거 채팅 로딩해왔을때
                                        middleScroll()
                                        proxy.scrollTo(middleID, anchor: .top)
                                        isLoadNew.toggle()
                                    } else {
                                        // 상대방에 채팅 보냈을때
                                        proxy.scrollTo(bottomID, anchor: .bottom)
                                    }
                                }
                            }
                    } else {
                        Rectangle()
                            .id(bottomID)
                            .frame(height: 5)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.clear)
                            .onChange(of: messages.count) { newValue in
                                // TODO: if문에서의 조건과 같은지 꼭 확인하기
                                if isSendImage {
                                    // 내가 보낸 사진임을 깨닫고, 다시 닫음
                                    isSendImage.toggle()
                                }
                                sortedChat = sortChat(chat: messages)
                                sortedDay = sortedChat!.keys.sorted(by: { prev, next in
                                    return prev < next
                                })
                                if isSending {
                                    // 내가 보냈을때
                                    proxy.scrollTo(bottomID, anchor: .bottom)
                                    isSending.toggle()
                                } else {
                                    if isLoadNew == true {
                                        // 과거 채팅 로딩해왔을때
                                        middleScroll()
                                        proxy.scrollTo(middleID, anchor: .top)
                                        isLoadNew.toggle()
                                    } else {
                                        // 상대방에 채팅 보냈을때
                                        proxy.scrollTo(bottomID, anchor: .bottom)
                                    }
                                }
                            }
                    }
                }
            }
            .onTapGesture {
                // 키보드 내리는 코드
                self.endTextEditing()
            }
            .onAppear {
                // 초기 채팅 로드
                fetchChatting()
            }
        }
        // 사용자가 메세지 보내는 뷰
        VStack {
            HStack(alignment: .bottom) {
                // 사진 보내기 버튼
                Button {
                    // 이미지 피커 열기
                    isShowingImagePicker.toggle()
                } label: {
                    Image(systemName: "photo.badge.plus")
                        .foregroundStyle(.black)
                        .font(.title3)
                        .padding(.bottom, 10)
                }
                // 이미지 피커 시트
                .sheet(isPresented: $isShowingImagePicker) {
                    ImagePicker(image: $selectedUIImage)
                        .onDisappear(){
                            if selectedUIImage != nil {
                                showImage()
                                isRealSendSheet.toggle()
                            }
                        }
                }
                // 전송 전 사진 확인 페이지
                .fullScreenCover(isPresented: $isRealSendSheet) {
                    VStack {
                        HStack(alignment: .top) {
                            Button {
                                isRealSendSheet.toggle()
                            } label: {
                                Text("취소하기")
                            }
                            Spacer()
                            Button {
                                if isDeactivation {
                                    if let roomID = room.id {
                                        roomService.changeStatus(roomID: roomID, status: .deactivation)
                                    }
                                    isActive = false
                                } else {
                                    loadImage()
                                    isRealSendSheet.toggle()
                                }
                            } label: {
                                Text("보내기")
                            }
                        }
                        .padding(.horizontal, 10)
                        Spacer()
                        if let image = image {
                            // 사진첩에서 사진 불러오기 성공
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxHeight: .infinity)
                                .frame(maxWidth: .infinity)
                        } else {
                            // 이미지를 불러올 수 없을때
                            ZStack {
                                Rectangle()
                                    .foregroundStyle(.clear)
                                    .frame(maxHeight: .infinity)
                                    .frame(maxWidth: .infinity)
                                VStack(alignment: .center) {
                                    // TODO: 사진이 icloud에서 불러오는거면 로딩이 실패할수가 있음.. 이거 어캄?
                                    Text("이미지를 불러올 수 없습니다.")
                                    Text("\n다시 시도해주세요.")
                                }
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.pointColor)
                            }
                        }
                        Spacer()
                    }
                }
                
                // 메시지 입력
                HStack(alignment: .bottom) {
                    // 입력칸
                    TextField(isActive ? "메세지를 입력해주세요." : "비활성화된 모임입니다.", text: $messageText, axis: .vertical)
                        .lineLimit(4)
                        .onSubmit {
                            Task {
                                await sendMessage()
                            }
                        }
                    
                    // 입력칸 지우기 버튼
                    if !messageText.isEmpty {
                        Button {
                            messageText = ""
                        } label: {
                            Label("입력 취소", systemImage: "xmark.circle.fill")
                                .labelStyle(.iconOnly)
                                .font(.title3)
                                .foregroundStyle(Color.staticGray3)
                        }
                    }
                    
                    // 메시지 보내기 버튼
                    Button {
                        if !messageText.isEmpty {
                            if isDeactivation {
                                if let roomID = room.id {
                                    roomService.changeStatus(roomID: roomID, status: .deactivation)
                                }
                                isActive = false
                            } else {
                                Task {
                                    await sendMessage()
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "paperplane.circle.fill")
                            .font(.title3)
                            .tint(Color.pointColor)
                    }
                }
                .padding(10)
                .background(RoundedRectangle(cornerRadius: Configs.cornerRadius).foregroundStyle(Color.staticGray6))
            }
            .disabled(!isActive)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        
        // FIXME: 채팅방 제목으로
        .navigationTitle(room.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            // 오른쪽 메뉴창
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button  {
                        // 모임 디테일뷰
                        isRoomDetailShow.toggle()
                    } label: {
                        // TODO: 시스템 이미지 바꾸기
                        Label("모임 상세보기", systemImage: "")
                    }
                    Button  {
                        // 신고하기
                        isContactShow.toggle()
                    } label: {
                        Label("모임 신고하기", systemImage: "light.beacon.max.fill")
                    }
                    Button  {
                        // 모임 나가기
                        isGoOutRoomAlert.toggle()
                    } label: {
                        // TODO: 시스템 이미지 바꾸기
                        Label("모임 나가기", systemImage: "door.right.hand.open")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.black)
                    
                }
                .alert(Text("모임 나가기"), isPresented: $isGoOutRoomAlert) {
                    // 모임나가기 alert
                    Button(role: .cancel) {
                        isGoOutRoomAlert.toggle()
                    } label: {
                        Text("취소하기")
                    }
                    Button(role: .destructive) {
                        isGoOutRoomAlert.toggle()
                        goOutRoom(roomID: room.id!)
                    } label: {
                        Text("나가기")
                    }
                } message: {
                    Text("정말 이 모임을 나가시겠습니까?")
                        .fontWeight(.bold)
                }
                .sheet(isPresented: $isRoomDetailShow) {
                    // 모임 상세보기 sheet
                    RoomDetailView(room: room)
                        .padding(.top, Configs.paddingValue)
                }
                .fullScreenCover(isPresented: $isContactShow) {
                    // 신고하기 sheet
                    // FIXME: 신고가 안올라감. 뭐를 더 넣어줘야하는지
                    if let roomid = room.id {
                        ContactInputView(isPresented: $isContactShow, selectedContactCategory: .room, selectedRoomContact: roomid, selectedUserContact: "", contactThroughRoomView: true)
                    }
                }
                .fullScreenCover(isPresented: $isImageDetail) {
                    // 채팅 이미지 상세
                    VStack {
                        HStack(alignment: .top) {
                            Spacer()
                            Button {
                                isImageDetail.toggle()
                            } label: {
                                Text("닫기")
                                    .font(.title3)
                            }
                        }
                        .padding(.horizontal, 10)
                        VStack {
                            Spacer()
                            if let image = showImageDetail {
                                // 채팅 이미지 로드 성공
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxHeight: .infinity)
                                    .frame(maxWidth: .infinity)
                            } else {
                                // 이미지 로드 실패
                                ZStack {
                                    Rectangle()
                                        .foregroundStyle(.clear)
                                        .frame(maxHeight: .infinity)
                                        .frame(maxWidth: .infinity)
                                    VStack(alignment: .center) {
                                        Text("이미지를 불러올 수 없습니다.")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundStyle(Color.pointColor)
                                        Text("\n다시 시도해주세요.")
                                            .foregroundStyle(Color.pointColor)
                                    }
                                }
                            }
                            Spacer()
                        }
                    }
                }
            }
        }
        .toolbarRole(.editor)
        .onDisappear {
            guard let roomID = room.id else { return }
            
            // 방이 activation 상태일 때 마지막 채팅 업데이트
            if room.status == .activation {
                lastChatModel.updateFile(roomID: roomID, lastChat: messages.last)
            }
        }
    }
    
    // 모임 나가기
    private func goOutRoom(roomID: String) {
        Task {
            do {
                try chattingService.sendMessage(message: "\(uid)_퇴장")
                if let userModel = userService.loginedUser {
                    if userModel.id == room.leaderID {
                        changeStateDeleteRoom()
                        if let roomId = room.id {
                            loadRoomViewModel.deleteRoom(roomId: roomId)
                        }
                    }
                }
                try await roomService.leaveRoom(roomID: roomID)
                dismiss()
            } catch {
                Configs.printDebugMessage("error: \(error)")
            }
        }
    }
    
    // 채팅 불러오는 함수
    private func fetchChatting() {
        if !isfetchFinish {
            Task {
                do {
                    // 유저 정보 불러옴
                    let tempuid = try await userService.loggedInUserInfo()?.id
                    uid = tempuid!
                    // 채팅 불러옴
                    try await chattingService.fetchChatting()
                    DispatchQueue.main.async {
                        // 처음 채팅 로드시에 필요한 정보 저장
                        if isFirstEnter {
                            loadingNewID = messages.first?.id
                            loadingMiddleID = messages.first?.id
                            isFirstEnter.toggle()
                        }
                    }
                } catch let error {
                    switch error.self {
                    case FetchError.noMoreFetch:
                        isfetchFinish.toggle()
                    default:
                        Configs.printDebugMessage("error: \(error)")
                    }
                }
            }
        }
    }
    
    private func changeStateDeleteRoom() {
        if let roomId = room.id {
            roomService.changeStatus(roomID: roomId, status: .delete)
        }
    }
    
    // 중간 스크롤 위한 위치 저장 함수
    private func middleScroll() {
        loadingMiddleID = loadingNewID
        loadingNewID = messages.first?.id
    }
    
    // 채팅에 날짜 보여주는 텍스트 함수
    // FIXME: 텍스트 함수 변경해야함..
    private func toStringChatDay(chat: ChattingModel) -> String {
        return DateService.shared.formattedString(date: chat.date, format: "yyyy년 MM월 dd일")
    }
    
    // chat 날짜별 정렬 함수
    func sortChat(chat: [ChattingModel]) -> [Int: [ChattingModel]] {
        let classificationChat = Dictionary
            .init(grouping: messages, by: {Int($0.date.toStringDate()) ?? 0})
        return classificationChat
    }
    
    // 메세지 보내는 함수
    private func sendMessage() async {
        do {
            try await chattingService.sendMessage(uid: uid, message: messageText, type: .text)
            DispatchQueue.main.async {
                messageText = ""
            }
        } catch {
            Configs.printDebugMessage("에러: \(error)")
        }
        isSending.toggle()
    }
    
    // 메시지 뷰
    @ViewBuilder
    private func chatView(chat: ChattingModel) -> some View {
        let isYou = uid != chat.userID
        VStack {
            switch chat.type {
                // 내용이 Text 일때
            case .text:
                HStack {
                    if !isYou {
                        Spacer()
                    }
                    ChatMessageCellView(leaderID: room.leaderID, message: chat, isYou: isYou, messageType: .text)
                    if isYou {
                        Spacer()
                    }
                }
                
                // 내용이 이미지 일때
            case .image:
                HStack {
                    if !isYou {
                        Spacer()
                    }
                    Button {
                        Task {
                            // 이미지 로드
                            showImageDetail = await ImageCacheManager.shared.findImageFromCache(imagePath: chat.message)
                        }
                        isImageDetail.toggle()
                    } label: {
                        ChatMessageCellView(leaderID: room.leaderID, message: chat, isYou: isYou, messageType: .image)
                    }
                    if isYou {
                        Spacer()
                    }
                }
                
                // system 메시지 - 입장 퇴장
            case .notice:
                ChatNoticeMessageView(message: chat.message)
            }
        }
    }
    
    // 이미지 보내기전 보여주기 위해 로딩하는 함수
    func showImage() {
        guard let selectedImage = selectedUIImage else { return }
        image = Image(uiImage: selectedImage)
        
    }
    
    // 이미지를 보내는 함수
    func loadImage() {
        // 현재 내가 보낸 이미지가 있음을 알려줌
        isSendImage.toggle()
        
        // 이미지 사이즈 조절 채팅방 최대 이미지 가로 길이 1024
        guard let selectedImage = (selectedUIImage?.size.width)! < 840 ? selectedUIImage : selectedUIImage?.resizeWithWidth(width: 840) else { return }
        // 무손실 png파일로 변경
        guard let imageData = selectedImage.jpegData(compressionQuality: 5.0) else { return }
        // 이미지 경로 설정
        let dayString = DateService.shared.formattedString(date: Date(), format: "yyyyMMddHHmmss")
        let roomID = room.id ?? "NONE"
        let imageDir: [StorageService.StorageName: [String]] = [.chatting: [roomID, uid, dayString]]
        
        Task {
            do {
                // 이미지의 이름은 유저아이디와 현재 시간을 이용해 지정
                let imagePath = try await storageService.imageUpload(dirs: imageDir, image: imageData) ?? "NONE"
                // 파베 메시지로 올림
                try await chattingService.sendMessage(uid: uid, message: imagePath, type: .image)
                // 캐시에 올림
                ImageCacheManager.shared.updateImageFirst(name: imagePath, image: selectedImage)
                // 이미지 전송 끝냄
                DispatchQueue.main.async {
                    isSending.toggle()
                }
            } catch {
                Configs.printDebugMessage("에러: \(error)")
            }
        }
    }
    
    // 맨 위로 스크롤뷰 당겼을때 실행되는 함수
    func scrollEvent(_ offset: CGPoint) {
        if offset.y > 0 {
            if prevValue <= 0.01 {
                fetchChatting()
                isLoadNew.toggle()
            }
        }
        prevValue = offset.y
    }
}

//#Preview {
//    NavigationStack {
//        ChatView(roomID: "9XnfdhSeiuSfqlNeZNM5", room: RoomModel(title: "우리 ㅇ카테고리버튼도 피드백저굥않함??", category: .hobby, dateTime: Date(), content: "저거저거 빠져있자나요 보더라인 라라라인", coverImage: "https://firebasestorage.googleapis.com:443/v0/b/zzirit-4b0a3.appspot.com/o/RoomCoverImage%2FFBBE1800-F3C4-4D07-8239-6342C23B86C2?alt=media&token=beb1549a-c680-48a3-bd0c-18773de9dd7d", isOnline: true, status: .activation, leaderID: "bCw58qthxIbxTu4j2kl36dCmj8A3", limitPeople: 2), isActive: true)
//            .environmentObject(UserService())
//    }
//}
