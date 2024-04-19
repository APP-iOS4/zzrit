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
    
    // 모임 정보
    let room: RoomModel
    // 모임방 활성화 여부
    var isActive: Bool
    
    // 유저 정보 불러옴
    @EnvironmentObject private var userService: UserService
    // 유저모델 변수
    @State private var userModel: UserModel?
    
    // FIXME: 현재 계정의 uid로 바꾸어 주기
    @State private var uid = ""
    
    // 모임방 나가기 기능을 위한 것
    private let roomService = RoomService.shared
    // 채팅의 이미지 저장을 위한 것
    var storageService = StorageService()
    
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
    
    // 스크롤뷰용
    // 스크롤뷰의 맨밑 담당
    @Namespace private var bottomID
    // 스크롤뷰의 중간 담당
    @Namespace private var middleID
    // 스크롤뷰 맨 위로 올렸을때
    @State var prevValue: Double = 0
    
    // 모임 상세보기 시트
    @State private var isRoomDetailShow = false
    // 모임 나가기 알럿
    @State private var isGoOutRoomAlert = false
    // 신고하기 시트
    @State private var isContactShow = false
    
    // 모임 정보 init
    init(roomID: String, room: RoomModel, isActive: Bool) {
        self._chattingService = StateObject(wrappedValue: ChattingService(roomID: roomID))
        self.room = room
        self.isActive = isActive
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
                                    .padding(10)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        ForEach(sortedDay, id: \.self) { day in
                            // 바뀐 날짜 표시
                            VStack {
                                Text(toStringChatDay(chat: sortedChat?[day]!.first ?? ChattingModel(userID: "실패", message: "실패", type: .text)))
                                    .font(.caption)
                                    .foregroundStyle(Color.staticGray3)
                                    .frame(maxWidth: .infinity)
                            }
                            .padding(.vertical, 3)
                            
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
                                loadImage()
                                isRealSendSheet.toggle()
                            } label: {
                                Text("보내기")
                            }
                        }
                        .padding(Configs.paddingValue)
                        Spacer()
                        if let image = image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: .infinity, height: .infinity)
                        } else {
                            Rectangle()
                                .frame(width: .infinity, height: .infinity)
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
                            sendMessage()
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
                            sendMessage()
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
            .padding(.top, 5)
        }
        .padding(.horizontal, Configs.paddingValue)
        
        // FIXME: 채팅방 제목으로
        .navigationTitle(room.title)
        .navigationBarTitleDisplayMode(.inline)
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
                .sheet(isPresented: $isContactShow) {
                    // 신고하기 sheet
                    // FIXME: 신고가 안올라감. 뭐를 더 넣어줘야하는지
                    ContactInputView()
                        .padding(.top, Configs.paddingValue)
                }
            }
        }
        .toolbarRole(.editor)
    }
    
    // 모임 나가기
    private func goOutRoom(roomID: String) {
        Task {
            do {
                try await roomService.leaveRoom(roomID: roomID)
            } catch {
                print("error: \(error)")
            }
        }
    }
    
    // 채팅 불러오는 함수
    private func fetchChatting() {
        if !isfetchFinish {
            Task {
                do {
                    // 유저 정보 불러옴
                    let tempuid = try await userService.loginedUserInfo()?.id
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
                        print("error: \(error)")
                    }
                }
            }
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
    private func sendMessage() {
        do {
            try chattingService.sendMessage(uid: uid, message: messageText, type: .text)
            DispatchQueue.main.async {
                messageText = ""
            }
        } catch {
            print("에러: \(error)")
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
                    ChatMessageCellView(message: chat, isYou: isYou, messageType: .text)
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
                    ChatMessageCellView(message: chat, isYou: isYou, messageType: .image)
                    if isYou {
                        Spacer()
                    }
                }
                
                // system 메시지
            case .notice:
                Text(chat.message)
                    .foregroundStyle(Color.pointColor)
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color.lightPointColor)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
    
    // 이미지 보내기전 보여주기 위해 로딩하는 함수
    func showImage() {
        guard let selectedImage = selectedUIImage else { return }
        Task {
            image = Image(uiImage: selectedImage)
        }
    }
    
    // 이미지를 보내는 함수
    func loadImage() {
        // 현재 내가 보낸 이미지가 있음을 알려줌
        isSendImage.toggle()
        
        guard let selectedImage = selectedUIImage else { return }
        guard let imageData = selectedImage.pngData() else { return }
        Task {
            do {
                // 이미지의 이름은 유저아이디와 현재 시간을 이용해 지정
                let downloadURL = try await storageService.imageUpload(topDir: .chatting, dirs: ["\(uid)", Date().toString()], image: imageData)
                try chattingService.sendMessage(uid: uid, message: downloadURL, type: .image)
                
                DispatchQueue.main.async {
                    isSending.toggle()
                }
            } catch {
                print("에러: \(error)")
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

#Preview {
    NavigationStack {
        ChatView(roomID: "1Ab05L2UJXVpbYD7qxNc", room: RoomModel(title: "같이 모여서 가볍게 치맥하실 분...", category: .hobby, dateTime: Date(), content: "", coverImage: "https://picsum.photos/200", isOnline: false, status: .activation, leaderID: "", limitPeople: 8), isActive: true)
            .environmentObject(UserService())
    }
}
