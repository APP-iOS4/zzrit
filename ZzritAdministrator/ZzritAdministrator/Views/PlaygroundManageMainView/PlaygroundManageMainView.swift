//
//  PlaygroundManageMainView.swift
//  ZzritAdministrator
//
//  Created by Healthy on 4/8/24.
//

import SwiftUI
import ZzritKit

struct PlaygroundManageMainView: View {
    
    // TODO: 데이터 연결 시 사용할 코드
    // @State private var pickGroupId: PlaygroundModel.ID? = nil
    
    // TODO: 더미 데이터들 -> 찐 데이터로 교체 해야함
    @State private var pickGroupId: DummyRoom? = nil
    @State private var dummyData = DummyRoom.dummyRooms
    @State private var istActive: Bool = true
    @State private var dummyUsers = DummyUsers.dummyData
    
    // 찐 데이타 타입 연결
    @State private var dummyModeledRooms = DummyModeledRoom.dummyData
    @State private var selectedRoom: DummyModeledRoom? = nil
    // 모임 활성화,비활성화 시 보여줄 얼럿
    @State private var showActiveAlert = false
    
    // TODO: 데이터 연결 후 뷰 분리 예정입니다.
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack {
                SearchField(action: {
                    print("검색")
                })
            }
//            
//            HStack(spacing: 20) {
//                ScrollView {
//                    LazyVStack(pinnedViews: [.sectionHeaders]) {
//                        Section(header: PlaygroundSectionHeader())
//                        {
//                            ForEach(dummyData) { room in
//                                Button {
//                                    selectedRoom = room
//                                } label: {
//                                    HStack {
//                                        Text(room.title)
//                                            .frame(minWidth: 100, alignment: .leading)
//                                            .multilineTextAlignment(.leading)
//                                        Spacer()
//                                        
//                                        Divider()
//                                        
//                                        Text("\(room.limitPeople)")
//                                            .minimumScaleFactor(0.5)
//                                            .frame(width: 90, alignment: .center)
//                                        
//                                        Divider()
//                                        
//                                        Text(room.date)
//                                            .minimumScaleFactor(0.5)
//                                            .frame(width: 90, alignment: .leading)
//                                            .multilineTextAlignment(.leading)
//                                        
//                                        Divider()
//                                        
//                                        Text(room.isActive ? "활성화" : "비활성화")
//                                            .minimumScaleFactor(0.5)
//                                            .frame(width: 90, alignment: .leading)
//                                            .multilineTextAlignment(.leading)
//                                    }
//                                    .font(.title3)
//                                    .foregroundStyle(room == selectedRoom ? Color.pointColor : Color(uiColor: .label))
//                                    .padding(10)
//                                }
//                            }
//                        }
//                    }
//                }
//                .listStyle(.inset)
//                .overlay {
//                    RoundedRectangle(cornerRadius: Constants.commonRadius)
//                        .stroke(Color.staticGray3, lineWidth: 1.0)
//                }
//                .onTapGesture(count: 2, perform: {
//                    withAnimation{
//                        pickGroupId = nil
//                    }
//                })
//                
//                if let selectedRoom {
//                    VStack(spacing: 0) {
//                        HStack {
//                            Text("모임 정보")
//                            
//                            Spacer()
//                            
//                            Text("현재 상태")
//                     
//                            Button {
//                                showActiveAlert = true
//                            } label: {
//                                Text(istActive ? "활성화" : "비황성화")
//                                    .fontWeight(.bold)
//                            }
//                            .buttonStyle(.borderedProminent)
//                            .tint(istActive ? Color.pointColor : Color.staticGray3)
//                        }
//                        .padding(.bottom, 5)
//                        .padding(.horizontal, 10)
//                        
//                        List {
//                            LabeledContent("방장 ID", value: "\(selectedRoom.leaderID)")
//                            
//                            Section {
//                                Text("\(selectedRoom.content)")
//                            } header: {
//                                Text("모임 소개")
//                            }
//
//                            /// 온라인 -> LabeledContent, 오프라인 -> Section
//                            if selectedRoom.isOnline {
//                                LabeledContent("플랫폼", value: "플랫폼 정보")
//                            } else {
//                                Section {
//                                    Text("위치정보")
//                                } header: {
//                                    Text("위치")
//                                }
//                            }
//                            
//                            LabeledContent("카테고리", value: selectedRoom.category)
//                            LabeledContent("모임날짜", value: "\(selectedRoom.date)")
//                            LabeledContent("종료시간", value: "종료시간")
//                            LabeledContent("인원제한", value: "\(selectedRoom.limitPeople)")
//                        }
//                        .listStyle(.inset)
//                        .listRowSeparator(.hidden)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: Constants.commonRadius)
//                                .stroke(Color.staticGray3, lineWidth: 1.0)
//                        )
//                        .padding(.bottom, 20)
//                        
//                        HStack {
//                            Text("참여자 정보")
//                            Spacer()
//                        }
//                        .padding(.leading, 10)
//                        .padding(.bottom, 10)
//                        
//                        List {
//                            ForEach(dummyUsers) { user in
//                                Button {
//                                    
//                                } label: {
//                                    VStack {
//                                        Text(user.email)
//                                    }
//                                }
//                            }
//                        }
//                        .listStyle(.inset)
//                        .overlay (
//                            RoundedRectangle(cornerRadius: Constants.commonRadius)
//                                .stroke(Color.staticGray3, lineWidth: 1.0)
//                        )
//                    }
//                    .frame(width: 300)
//                }
//
//            }
        }
//        .padding(20)
//        .alert(isPresented: $showActiveAlert, content: {
//            // TODO: SelRoom.isActive로 수정해야 함
//            istActive ? getInactiveAlert() : getActiveAlert()
//        })
    }
    
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
struct DummyRoom: Identifiable, Equatable {
    /// 모임 제목
    public var title: String
    
    /// 카테고리
    public var category: String
    
    /// 모임 아이디 (PK)
    public var id: String = UUID().uuidString
    /// 모임장 아이디
    public var leaderID: String
    
    /// 모임 비활성화 여부
    public var isActive: Bool = false
    
    /// 모임 설명
    public var content: String
    
    /// 모임 진행 방식
    /// - true = 온라인, false = 오프라인
    public var isOnline: Bool
    
    /// 모임 진행 장소 좌표(위도)
    public var placeLatitude: Double?
    /// 모임 진행 장소 좌표(경도)
    public var placeLongitude: Double?
    /// 모임 진행 시간
    public var time: String
    /// 모임 인원 제한
    public var limitPeople: Int
    
    public var date = "12월 25일"
    
    /// 모임 삭제 여부
    /// - DB에서는 실제로 삭제되지는 않지만 isRemoved가 true일 경우 유저에게 표시되지 않아야 합니다.
    public var isRemoved: Bool = false
    
    static let dummyRooms: [DummyRoom] = [
        DummyRoom(title: "더미 5635 123 123 134 324 1324   3모임", category: "운동", leaderID: "leaderID.string", content: "모임 설명입니다. 설명입니다. 설설서럿ㄹ 명명명 134 134 1324 1234. 34. 34 1234 1234 1234 13434 234 234 234 234. 234 234몀ㅇ", isOnline: false, time: "12시 20분", limitPeople: 12),
        
        DummyRoom(title: "온라인 더미 모임", category: "운동", leaderID: "leaderID.string", content: "모임 설명입니다. 설명입니다. 설설서럿ㄹ 명명명몀ㅇ", isOnline: true, time: "12시 20분", limitPeople: 12),
        
        DummyRoom(title: "온라인 더미 모임", category: "운동", leaderID: "leaderID.string", content: "모임 설명입니다. 설명입니다. 설설서럿ㄹ 명명명몀ㅇ", isOnline: true, time: "12시 20분", limitPeople: 12, date: "1월 1일", isRemoved: true)
    ]
}

struct DummyUsers: Identifiable {
    public var id = UUID().uuidString
    public var name: String
    public var email : String
    
    static let dummyData: [DummyUsers] = [
        DummyUsers(name: "분노의 호두", email: "sepfoksepf@ffsefs"),
        DummyUsers(name: "분노의 포도", email: "sepfoksepf@ffsefs"),
        DummyUsers(name: "분노의 자몽", email: "sepfoksepf@ffsefs"),
        DummyUsers(name: "분노의 오렌지", email: "sepfoksepf@ffsefs"),
        DummyUsers(name: "분노의 망고", email: "sepfoksepf@ffsefs"),
        DummyUsers(name: "분노의 청포도", email: "sepfoksepf@ffsefs"),
        DummyUsers(name: "분노의 복숭아", email: "sepfoksepf@ffsefs"),
        DummyUsers(name: "분노의 배", email: "sepfoksepf@ffsefs"),
        DummyUsers(name: "분노의 자두", email: "sepfoksepf@ffsefs"),
        DummyUsers(name: "분노의 수박", email: "sepfoksepf@ffsefs"),
    ]
}


struct DummyModeledRoom {
    static let dummyData: [RoomModel] = [
        RoomModel(title: "칼바람 빠른 5인팟", category: "게임", dateTime: Date(), content: "모임 설명입니다 글자수에 따른 변화를 보고 있습니다. 모임 설명입니다 글자수에 따른 변화를 보고 있습니다. 모임 설명입니다 글자수에 따른 변화를 보고 있습니다. 모임 설명입니다 글자수에 따른 변화를 보고 있습니다. 모임 설명입니다 글자수에 따른 변화를 보고 있습니다. 모임 설명입니다 글자수에 따른 변화를 보고 있습니다.", coverImage: URL(string: "https://picsum.photos/250/250")!, isOnline: true, status: isActive.active, leaderID: "LeaderIDAAA", limitPeople: 4),
        
        RoomModel(title: "몬헌이 너무 하고싶어요", category: "게임", dateTime: Date(), content: "모임 설명입니다 글자수에 따른 변화를 보고 있습니다.", coverImage: URL(string: "https://picsum.photos/250/250")!, isOnline: true, status: isActive.active, leaderID: "LeaderIDAAA", limitPeople: 12),
        
        RoomModel(title: "나랑 같이 배드민턴 칠사람", category: "운동", dateTime: Date(), content: "모임 설명입니다 글자수에 따른 변화를 보고 있습니다. 모임 설명입니다 글자수에 따른 변화를 보고 있습니다.", coverImage: URL(string: "https://picsum.photos/250/250")!, isOnline: false, status: isActive.active, leaderID: "LeaderIDAAA", limitPeople: 5),
        
        RoomModel(title: "축구는 아침축구", category: "운동", dateTime: Date(), content: "모임 설명입니다 글자수에 따른 변화를 보고 있습니다. 모임 설명입니다 글자수에 따른 변화를 보고 있습니다. 모임 설명입니다 글자수에 따른 변화를 보고 있습니다.", coverImage: URL(string: "https://picsum.photos/250/250")!, isOnline: false, status: isActive.active, leaderID: "LeaderIDAAA", limitPeople: 2),
        
        RoomModel(title: "헬스장 같이 가실 분", category: "운동", dateTime: Date(), content: "모임 설명입니다 글자수에 따른 변화를 보고 있습니다. 모임 설명입니다 글자수에 따른 변화를 보고 있습니다. 모임 설명입니다 글자수에 따른 변화를 보고 있습니다. 모임 설명입니다 글자수에 따른 변화를 보고 있습니다. 모임 설명입니다 글자수에 따른 변화를 보고 있습니다. 모임 설명입니다 글자수에 따른 변화를 보고 있습니다.", coverImage: URL(string: "https://picsum.photos/250/250")!, isOnline: false, status: isActive.active, leaderID: "LeaderIDAAA", limitPeople: 9),
        
        RoomModel(title: "리듬게임은 2인 게임이다", category: "게임", dateTime: Date(), content: "모임 설명입니다 글자수에 따른 변화를 보고 있습니다. 모임 설명입니다 글자수에 따른 변화를 보고 있습니다.", coverImage: URL(string: "https://picsum.photos/250/250")!, isOnline: true, status: isActive.active, leaderID: "LeaderIDAAA", limitPeople: 10),
        
        RoomModel(title: "못된 방이라 비횔성화인 방", category: "나쁨", dateTime: Date(), content: "못~난놈", coverImage: URL(string: "https://picsum.photos/250/250")!, isOnline: true, status: isActive.deactive, leaderID: "LeaderIDAAA", limitPeople: 2),
    ]
}
