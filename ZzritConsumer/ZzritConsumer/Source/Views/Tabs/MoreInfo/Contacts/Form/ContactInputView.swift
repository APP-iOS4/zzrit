//
//  ContactInputView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/9/24.
//

import SwiftUI

import ZzritKit

struct ContactInputView: View {
    @EnvironmentObject private var userService: UserService
    @EnvironmentObject private var contactService: ContactService
    
    private let roomService = RoomService.shared
    
    // 문의 제목 스트링 변수
    @State private var contactTitle: String = ""
    // 문의 내용 스트링 변수
    @State private var contactContent: String = ""
    // 문의 카테고리 변수
    @State private var selectedContactCategory: ContactCategory
    // 문의할 모임 변수
    @State private var selectedRoomContact: String
    // 문의할 모임 내 회원 변수
    @State private var selectedUserContact: String
    // '문의하기'버튼을 눌렀을 시
    @State private var isPressContactButton: Bool = false
    // 모임 배열 변수
    @State private var rooms: [RoomModel] = []
    // 모임 내 회원 변수
    @State private var users: [UserModel] = []
    // 방 신고 버튼 눌렀을 시, 방 타이틀
    @State private var roomTitle: String = ""
    
    @Binding var isPresented: Bool
    
    let contactThroughRoomView: Bool
    
    init(isPresented: Binding<Bool>, selectedContactCategory: ContactCategory = .app, selectedRoomContact: String = "", selectedUserContact: String = "", contactThroughRoomView: Bool = false) {
        self._isPresented = isPresented
        self.selectedContactCategory = selectedContactCategory
        self.selectedRoomContact = selectedRoomContact
        self.selectedUserContact = selectedUserContact
        self.contactThroughRoomView = contactThroughRoomView
    }
    
    //MARK: - body
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    // 문의 제목을 받는 곳
                    TextField("문의 제목을 입력해주세요", text: $contactTitle)
                        .foregroundStyle(Color.staticGray1)
                        .roundedBorder()
                        .padding(.bottom, Configs.paddingValue)
                    
                    // 문의 종류를 받는 곳
                    HStack {
                        Text("문의 종류")
                        
                        Spacer()
                        
                        // Picker를 통해 selectedContactCategory에 값을 바인딩한다.
                        Picker("Choose contact category", selection: $selectedContactCategory) {
                            ForEach(ContactCategory.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                    }
                    .foregroundStyle(Color.staticGray1)
                    .roundedBorder()
                    .padding(.bottom, Configs.paddingValue)
                    
                    // 만약 문의 종류가 모임이라면....
                    if selectedContactCategory == .room {
                        // 문의 종류가 모임 관련 시 어떤 모임인지 선택하는 곳
                        HStack {
                            Text("모임")
                            
                            Spacer()
                            
                            if !contactThroughRoomView {
                                // Picker를 통해 selectedRoomContact에 값을 바인딩한다.
                                if #available(iOS 17.0, *) {
                                    Picker("Choose room title", selection: $selectedRoomContact) {
                                        ForEach(rooms) { room in
                                            Text(room.title)
                                                .tag(room.id!)
                                        }
                                    }
                                    .onChange(of: selectedRoomContact) { _, _ in
                                        fetchUsers()
                                    }
                                } else {
                                    Picker("Choose room title", selection: $selectedRoomContact) {
                                        ForEach(rooms) { room in
                                            Text(room.title)
                                                .tag(room.id!)
                                        }
                                    }
                                    .onChange(of: selectedRoomContact) { _ in
                                        fetchUsers()
                                    }
                                }
                            } else {
                                Text(roomTitle)
                                    .foregroundStyle(Color.pointColor)
                                    .onAppear {
                                        fetchUsers()
                                    }
                            }
                        }
                        .foregroundStyle(Color.staticGray1)
                        .roundedBorder()
                        .padding(.bottom, Configs.paddingValue)
                        
                        if selectedRoomContact != "" {
                            // 모임 선택시 회원 목록 뜸
                            HStack {
                                Text("회원")
                                
                                Spacer()
                                
                                // Picker를 통해 selectedUserContact에 값을 바인딩한다.
                                Picker("Choose member", selection: $selectedUserContact) {
                                    Text("신고할 회원을 선택하세요.")
                                        .tag("")
                                    if users.isEmpty {
                                        Text("참가한 회원이 없습니다.")
                                            .tag("")
                                            .foregroundStyle(.red)
                                    } else {
                                        ForEach(users) { user in
                                            Text(user.userName)
                                                .tag(user.id!)
                                        }
                                    }
                                }
                            }
                            .foregroundStyle(Color.staticGray1)
                            .roundedBorder()
                            .padding(.bottom, Configs.paddingValue)
                        }
                    }
                    
                    // 문의 내용을 작성하는 곳
                    TextEditor(text: $contactContent)
                        .foregroundStyle(Color.staticGray1)
                        .frame(height: 250, alignment: .top)
                        .roundedBorder()
                        .padding(.bottom, Configs.paddingValue)
                }
                
                GeneralButton("문의하기", isDisabled: contactTitle.isEmpty) {
                    writeContact()
                }
                .navigationDestination(isPresented: $isPressContactButton) {
                    ContactInputCompleteView(isPresented: $isPresented)
                }
            }
            .padding(.vertical, Configs.paddingValue)
            .padding(.horizontal, Configs.paddingValue)
            .navigationTitle("문의하기")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.black)
                    }
                }
            }
            .onTapGesture {
                self.endTextEditing()
            }
            .onAppear {
                if !contactThroughRoomView {
                    fetchRooms()
                } else {
                    fetchRoomThroughRoomView()
                }
            }
        }
    }
    
    private func fetchRooms() {
        Task {
            do {
                if let joinedRooms = try await userService.loggedInUserInfo()?.joinedRooms {
                    for roomID in joinedRooms {
                        if let room = try await roomService.roomInfo(roomID) {
                            rooms.append(room)
                        }
                    }
                }
            } catch {
                Configs.printDebugMessage("에러: \(error)")
            }
        }
    }
    
    private func fetchRoomThroughRoomView() {
        Task {
            do {
                if let room = try await roomService.roomInfo(selectedRoomContact) {
                    roomTitle = room.title
                }
            } catch {
                Configs.printDebugMessage("에러: \(error)_")
            }
        }
    }
    
    private func fetchUsers() {
        users.removeAll()
        
        Task {
            do {
                let userUID = try await userService.loggedInUserInfo()?.id
                let joinedUsers = try await roomService.joinedUsers(roomID: selectedRoomContact)
                for user in joinedUsers {
                    if let userModel = try await userService.findUserInfo(uid: user.userID) {
                        if userUID != userModel.id {
                            users.append(userModel)
                        }
                    }
                }
            } catch {
                Configs.printDebugMessage("에러: \(error)")
            }
        }
    }
    
    private func writeContact() {
        Task {
            do {
                if let userUID = try await userService.loggedInUserInfo()?.id {
                    let contact = ContactModel(category: selectedContactCategory, title: contactTitle, content: contactContent, requestedDated: .now, requestedUser: userUID, targetRoom: selectedRoomContact, targetUser: [selectedUserContact])
                    try contactService.writeContact(contact)
                    isPressContactButton.toggle()
                }
            } catch {
                Configs.printDebugMessage("에러: \(error)")
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContactInputView(isPresented: .constant(true))
            .environmentObject(UserService())
            .environmentObject(ContactService())
    }
}
