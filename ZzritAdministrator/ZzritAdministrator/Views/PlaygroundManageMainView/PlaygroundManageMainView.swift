//
//  PlaygroundManageMainView.swift
//  ZzritAdministrator
//
//  Created by Healthy on 4/8/24.
//

import SwiftUI
import ZzritKit

struct PlaygroundManageMainView: View {
    
    // TODO: 더미 데이터 -> 모임 활성화, 비활성화 요청 로직 후 수정 예정
    @State private var istActive: Bool = true
    
    // 데이타 타입 연결
    @State private var dummyModeledRooms = DummyModeledRoom.dummyData
    @State private var dummyModeledUsers = DummyModeledUsers.dummyUsers
    @State private var selectedRoom: RoomModel? = nil
   
    // 모임 활성화,비활성화 시 보여줄 얼럿
    @State private var showActiveAlert = false
    
    // TODO: 뷰 뷴리는 로그인 뷰부터 짜고(급해서) 진행하겠습니다
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            SearchField(action: {
                print("검색")
            })
            
            HStack(spacing: 20) {
                ScrollView {
                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                        Section(header: PlaygroundSectionHeader()) {
                            ForEach(dummyModeledRooms) { room in
                                Button {
                                    selectedRoom = room
                                } label: {
                                    HStack {
                                        Text(room.title)
                                            .frame(minWidth: 100, alignment: .leading)
                                            .multilineTextAlignment(.leading)
                                        Spacer()
                                        
                                        Divider()
                                        
                                        Text("1 / \(room.limitPeople)")
                                            .frame(width: 80, alignment: .leading)
                                        
                                        Divider()
                                        
                                        Text("need Date")
                                            .frame(width: 90, alignment: .leading)
                                            .multilineTextAlignment(.leading)
                                        
                                        Divider()
                                        
                                        
                                        Text(room.status == ActiveType.activation ? "활성화" : "비활성화")
                                            .frame(width: 90, alignment: .leading)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .font(.title3)
                                    .foregroundStyle(room.id == selectedRoom?.id ? Color.pointColor : Color.black)
                                    .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                                }
                            }
                        }
                    }
                }
                .overlay {
                    RoundedRectangle(cornerRadius: Constants.commonRadius)
                        .stroke(Color.staticGray3, lineWidth: 1.0)
                }
                
                if let selectedRoom {
                    VStack(spacing: 0) {
                        HStack {
                            Text("모임 정보")
                                                        
                            Spacer()
                            
                            Text("현재: ")
                     
                            // TODO: 활성화 비활성화 데이터 연결 필요 => 서버에 요청할 함수들
                            Button {
                                showActiveAlert = true
                            } label: {
                                Text(istActive ? "활성화" : "비활성화")
                                    .fontWeight(.bold)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(istActive ? Color.pointColor : Color.staticGray3)
                        }
                        .padding(.bottom, 5)
                        .padding(.horizontal, 10)
                        
                        List {
                            LabeledContent("방장 ID", value: "\(selectedRoom.leaderID)")
                            
                            Section {
                                Text("\(selectedRoom.content)")
                            } header: {
                                Text("모임 소개")
                            }

                            /// 온라인 -> LabeledContent, 오프라인 -> Section
                            if selectedRoom.isOnline {
                                LabeledContent("플랫폼", value: "플랫폼 정보")
                            } else {
                                Section {
                                    // TODO: 위치 정보 데이터 처리 로직 필요
                                    Text("위치정보")
                                } header: {
                                    Text("위치")
                                }
                            }
                            
                            LabeledContent("카테고리", value: selectedRoom.category.rawValue)
                            // TODO: 데이트 포매터 필요
                            LabeledContent("모임날짜", value: "날짜 정보")
                            // TODO: 데이트 포매터 필요
                            LabeledContent("종료시간", value: "종료시간")
                            LabeledContent("인원제한", value: "\(selectedRoom.limitPeople)")
                        }
                        .listStyle(.inset)
                        .listRowSeparator(.hidden)
                        .overlay(
                            RoundedRectangle(cornerRadius: Constants.commonRadius)
                                .stroke(Color.staticGray3, lineWidth: 1.0)
                        )
                        .padding(.bottom, 20)
                        
                        HStack {
                            Text("참여자 정보")
                            Spacer()
                        }
                        .padding(.leading, 10)
                        .padding(.bottom, 10)
                        
                        List {
                            ForEach(dummyModeledUsers) { user in
                                Button {
                                    
                                } label: {
                                    VStack {
                                        Text(user.userID)
                                    }
                                }
                            }
                        }
                        .listStyle(.inset)
                        .overlay (
                            RoundedRectangle(cornerRadius: Constants.commonRadius)
                                .stroke(Color.staticGray3, lineWidth: 1.0)
                        )
                    }
                    .frame(width: 260)
                }
            }
        }
        .padding(20)
        .alert(isPresented: $showActiveAlert, content: {
            // TODO: SelectedRoom.ActiveType로 수정해야 함
            istActive ? getInactiveAlert() : getActiveAlert()
        })
    }
    
    // TODO: 로직 수정해야 함
    /// 모임 비활성화 얼럿
    func getInactiveAlert() -> Alert {
        return Alert(
            title: Text("모임 비활성화"),
            message: Text("정말 모임을 비활성화 하시겠습니까?"),
            primaryButton: .destructive(Text("비활성화"), action: {
               istActive = false
            }),
            secondaryButton: .cancel(Text("취소")))
    }
    
    /// 모임 활성화 얼럿
    func getActiveAlert() -> Alert {
        return Alert(
            title: Text("모임 활성화"),
            message: Text("정말 모임을 활성화 하시겠습니까?"),
            primaryButton: .destructive(Text("활성화"), action: {
               istActive = true
            }),
            secondaryButton: .cancel(Text("취소")))
    }
}

#Preview {
    PlaygroundManageMainView()
}


// TODO: 더미 데이터 입니다 추후 삭제할 예정입니다.
struct DummyModeledUsers {
    static let dummyUsers: [UserModel] = [
        .init(id: UUID().uuidString, userID: "user1@example.com", userName: "A380", userImage: "person", gender: .male, birthYear: 2005, staticGuage: 99),
        .init(id: UUID().uuidString, userID: "us3442342341341234334er2@example.com", userName: "A350", userImage: "person", gender: .male, birthYear: 2010, staticGuage: 88),
        .init(id: UUID().uuidString, userID: "user3@example.com", userName: "A340", userImage: "person", gender: .female, birthYear: 1991, staticGuage: 66),
        .init(id: UUID().uuidString, userID: "user4@example.com", userName: "A330", userImage: "person", gender: .male, birthYear: 1992, staticGuage: 77),
        .init(id: UUID().uuidString, userID: "user5@example.com", userName: "A320", userImage: "person", gender: .female, birthYear: 1986, staticGuage: 75),
        .init(id: UUID().uuidString, userID: "user6@example.com", userName: "A300", userImage: "person", gender: .male, birthYear: 1971, staticGuage: 55),
        .init(id: UUID().uuidString, userID: "user7@example.com", userName: "A380", userImage: "person", gender: .male, birthYear: 2004, staticGuage: 90),
        .init(id: UUID().uuidString, userID: "user8@example.com", userName: "A350", userImage: "person", gender: .male, birthYear: 2009, staticGuage: 85),
        .init(id: UUID().uuidString,userID: "user9@example.com", userName: "A340", userImage: "person", gender: .female, birthYear: 1990, staticGuage: 70),
        .init(id: UUID().uuidString, userID: "user10@example.com", userName: "A330", userImage: "person", gender: .male, birthYear: 1991, staticGuage: 80),
        .init(id: UUID().uuidString, userID: "user11@example.com", userName: "A320", userImage: "person", gender: .female, birthYear: 1985, staticGuage: 77),
        .init(id: UUID().uuidString, userID: "user12@example.com", userName: "A300", userImage: "person", gender: .male, birthYear: 1970, staticGuage: 65),
    ]
}

struct DummyModeledRoom {
    static let dummyData: [RoomModel] = [
        RoomModel(title: "칼바람 빠른 5인팟", category: .game, dateTime: Date(), content: "모임 설명입니다 글자수에 따른 변화를 보고 있습니다. 모임 설명입니다 글자수에 따른 변화를 보고 있습니다. 모임 설명입니다 글자수에 따른 변화를 보고 있습니다. 모임 설명입니다 글자수에 따른 변화를 보고 있습니다. 모임 설명입니다 글자수에 따른 변화를 보고 있습니다. 모임 설명입니다 글자수에 따른 변화를 보고 있습니다.", coverImage: "https://picsum.photos/250/250", isOnline: true, status: ActiveType.activation, leaderID: "LeaderIDAAA", limitPeople: 4),
        
        RoomModel(title: "몬헌이 너무 하고싶어요", category: .game, dateTime: Date(), content: "모임 설명입니다 글자수에 따른 변화를 보고 있습니다.", coverImage: "https://picsum.photos/250/250", isOnline: true, status: ActiveType.activation, leaderID: "LeaderIDAAA", limitPeople: 12),
        
        RoomModel(title: "나랑 같이 배드민턴 칠사람", category: .game, dateTime: Date(), content: "모임 설명입니다 글자수에 따른 변화를 보고 있습니다. 모임 설명입니다 글자수에 따른 변화를 보고 있습니다.", coverImage: "https://picsum.photos/250/250", isOnline: false, status: ActiveType.activation, leaderID: "LeaderIDAAA", limitPeople: 5),
        
        RoomModel(title: "축구는 아침축구", category: .sport, dateTime: Date(), content: "모임 설명입니다 글자수에 따른 변화를 보고 있습니다. 모임 설명입니다 글자수에 따른 변화를 보고 있습니다. 모임 설명입니다 글자수에 따른 변화를 보고 있습니다.", coverImage: "https://picsum.photos/250/250", isOnline: false, status: ActiveType.activation, leaderID: "LeaderIDAAA", limitPeople: 2),
        
        RoomModel(title: "헬스장 같이 가실 분", category: .sport, dateTime: Date(), content: "모임 설명입니다 글자수에 따른 변화를 보고 있습니다. 모임 설명입니다 글자수에 따른 변화를 보고 있습니다. 모임 설명입니다 글자수에 따른 변화를 보고 있습니다. 모임 설명입니다 글자수에 따른 변화를 보고 있습니다. 모임 설명입니다 글자수에 따른 변화를 보고 있습니다. 모임 설명입니다 글자수에 따른 변화를 보고 있습니다.", coverImage: "https://picsum.photos/250/250", isOnline: false, status: ActiveType.activation, leaderID: "LeaderIDAAA", limitPeople: 9),
        
        RoomModel(title: "리듬게임은 2인 게임이다", category: .game, dateTime: Date(), content: "모임 설명입니다 글자수에 따른 변화를 보고 있습니다. 모임 설명입니다 글자수에 따른 변화를 보고 있습니다.", coverImage: "https://picsum.photos/250/250", isOnline: true, status: ActiveType.activation, leaderID: "LeaderIDAAA", limitPeople: 10),
        
        RoomModel(title: "끄룽 텝 마하나콘 아몬 라따나꼬신 마힌타라 유타야 마하딜록 폽 노파랏 랏차타니 부리롬 우돔랏차니웻 마하사탄 아몬 피만 아와딴 사팃 사카타띠야 윗사누깜 쁘라싯", category: .culture, dateTime: Date(), content: "끄룽 텝 마하나콘 아몬 라따나꼬신 마힌타라 유타야 마하딜록 폽 노파랏 랏차타니 부리롬 우돔랏차니웻 마하사탄 아몬 피만 아와딴 사팃 사카타띠야 윗사누깜 쁘라싯의 뜻을 알아보며 태국어를 공부합니다. 모임 설명입니다 글자수에 따른 변화를 보고 있습니다. 모임 설명입니다 글자수에 따른 변화를 보고 있습니다. 모임 설명입니다 글자수에 따른 변화를 보고 있습니다. 모임 설명입니다 글자수에 따른 변화를 보고 있습니다.", coverImage: "https://picsum.photos/250/250", isOnline: true, status: ActiveType.activation, leaderID: "LeaderIDAAA", limitPeople: 10),
        
        RoomModel(title: "못된 방이라 비횔성화인 방", category: .etc, dateTime: Date(), content: "못~난놈", coverImage: "https://picsum.photos/250/250", isOnline: true, status: ActiveType.deactivation, leaderID: "LeaderIDAAA", limitPeople: 2),
    ]
}
