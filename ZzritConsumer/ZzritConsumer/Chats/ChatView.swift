//
//  ChatView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/11/24.
//

import SwiftUI

import ZzritKit

struct ChatView: View {
    // TODO: 모임방의 ID
    @StateObject private var chattingService = ChattingService(roomID: "1Ab05L2UJXVpbYD7qxNc")
    var storageService = StorageService()
    
    // FIXME: 현재 계정의 uid로 바꾸어 주기
    var uid: String = "dPwldlqxdddddl"
    
    // 입력 메세지 변수
    @State private var messageText: String = ""
    
    // FIXME: 모임방 활성화 여부
    var isActive: Bool
    
    // 메시지 모델
    var messages: [ChattingModel] {
        chattingService.messages
    }
    
    // 메시지를 보냈을 때
    @State private var isSending = false
    // 새 메시지가 왔을 때
    @State private var isComingNew: String?
    // 불러올 채팅이 없음을 판별
    @State private var isfetchFinish = false
    @State private var isFirstEnter = true
    
    // 이미지 전송용
    @State private var isShowingImagePicker: Bool = false
    @State private var isRealSendSheet: Bool = false
    
    @State private var selectedUIImage: UIImage?
    @State private var image: Image?
    
    // 스크롤뷰용
    // 스크롤뷰의 맨밑 담당
    @Namespace private var bottomID
    // 스크롤뷰 맨 위로 올렸을때
    @State var prevValue: Double = 0
    
    var body: some View {
        
        // FIXME: 모임의 장소, 시간 정보 View 한번 들어가서 고쳐주세요.
        ChatRoomNoticeView()
        Divider()
        
        VStack {
            ScrollViewWithOffset(onScroll: scrollEvent) {
                ScrollViewReader { proxy in
                    LazyVStack {
                        // 더 이상 로드할 채팅이 없음을 알림
                        if isfetchFinish {
                            Text("- 대화내용의 끝입니다. -")
                                .foregroundStyle(Color.staticGray1)
                                .padding(10)
                                .frame(maxWidth: .infinity)
                        }
                        // 채팅 내용
                        ForEach(messages) { message in
                            chatView(chat: message)
                        }
                        // 새로 로딩 되었을때 가장 최근 메시지부터 보여주도록 설정
                        .onAppear {
                            proxy.scrollTo(bottomID, anchor: .bottom)
                        }
                    }
                    //스크롤 뷰의 맨밑 자리 담당
                    if #available(iOS 17.0, *) {
                        Rectangle()
                            .id(bottomID)
                            .frame(height: 1)
                            .foregroundStyle(.clear)
                        
                        // 메시지 텍스트 입력했을때 밑으로 가도록하는
                            .onChange(of: isSending) {
                                proxy.scrollTo(bottomID, anchor: .bottom)
                                isSending.toggle()
                            }
                            .onChange(of: messages.count) {
                                if isFirstEnter {
                                    proxy.scrollTo(bottomID, anchor: .bottom)
                                    isFirstEnter.toggle()
                                } else {
                                        if isComingNew == messages.last!.id {
                                            // 과거 메시지 로딩시에는 밑으로 안내려감
                                            
                                        } else {
                                            // 새로온 메시지 왔을때만 밑으로 가게하기
                                            isComingNew = messages.last!.id
                                            proxy.scrollTo(bottomID, anchor: .bottom)
                                        }
                                }
                            }
                        
                    } else {
                        Rectangle()
                            .id(bottomID)
                            .frame(height: 1)
                            .foregroundStyle(.clear)
                            .onChange(of: isSending) { newValue in
                                proxy.scrollTo(bottomID, anchor: .bottom)
                                isSending.toggle()
                            }
                            .onChange(of: messages.count) { newValue in
                                if isFirstEnter {
                                    proxy.scrollTo(bottomID, anchor: .bottom)
                                    isFirstEnter.toggle()
                                } else {
                                        if isComingNew == messages.last!.id {
                                            // 과거 메시지 로딩시에는 밑으로 안내려감
                                            
                                        } else {
                                            // 새로온 메시지 왔을때만 밑으로 가게하기
                                            isComingNew = messages.last!.id
                                            proxy.scrollTo(bottomID, anchor: .bottom)
                                        }
                                }
                            }
                    }
                }
            }
            .padding(.bottom, 5)
            .onTapGesture {
                self.endTextEditing()
            }
            .onAppear {
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
        .navigationTitle("수요일에 맥주 한잔 찌그려요~")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // 오른쪽 메뉴창
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Button {
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(.black)
                    }
                }
            }
        }
        .toolbarRole(.editor)
    }
    
    // 채팅 불러오는 함수
    private func fetchChatting() {
        if !isfetchFinish {
            Task {
                do {
                    try await chattingService.fetchChatting()
                    isComingNew = messages.last!.id
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
    
    // 메세지 보내는 함수
    private func sendMessage() {
        do {
            try chattingService.sendMessage(uid: uid, message: messageText, type: .text)
            messageText = ""
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
                
                // TODO: 날짜 넘어갈때 처리해야합니다.
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
        guard let selectedImage = selectedUIImage else { return }
        guard let imageData = selectedImage.pngData() else { return }
        Task {
            do {
                let downloadURL = try await storageService.imageUpload(topDir: .chatting, dirs: ["\(uid)", "chatting"], image: imageData)
                //                image = Image(uiImage: selectedImage)
                try chattingService.sendMessage(uid: uid, message: downloadURL, type: .image)
                
                print("업로드 완료: \(downloadURL)")
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
            }
        }
        prevValue = offset.y
    }
}

#Preview {
    NavigationStack {
        ChatView(isActive: true)
    }
}
