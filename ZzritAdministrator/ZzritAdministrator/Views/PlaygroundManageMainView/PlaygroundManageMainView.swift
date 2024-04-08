//
//  PlaygroundManageMainView.swift
//  ZzritAdministrator
//
//  Created by Healthy on 4/8/24.
//

import SwiftUI

struct PlaygroundManageMainView: View {
    
    // TODO: 데이터 연결 시 사용할 코드
    // @State private var pickGroupId: PlaygroundModel.ID? = nil
    
    // TODO: 더미 데이터들 -> 찐 데이터로 교체 해야함
    @State private var pickGroupId: DummyRoom? = nil
    @State private var dummyData = DummyRoom.dummyRooms
    @State private var isActive: Bool = true
    @State private var selectedRoom: DummyRoom? = nil
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack {
                SearchField(action: {
                    print("검색")
                })
            }
            
            HStack(spacing: 20) {
                ScrollView {
                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                        Section(header: PlaygroundSectionHeader())
                        {
                            ForEach(dummyData) { room in
                                Button {
                                    selectedRoom = room
                                } label: {
                                    HStack {
                                        Text(room.title)
                                            .frame(minWidth: 100, alignment: .leading)
                                            .multilineTextAlignment(.leading)
                                        Spacer()
                                        
                                        Divider()
                                        
                                        Text("\(room.limitPeople)")
                                            .minimumScaleFactor(0.5)
                                            .frame(width: 90, alignment: .center)
                                        
                                        Divider()
                                        
                                        Text(room.date)
                                            .minimumScaleFactor(0.5)
                                            .frame(width: 90, alignment: .leading)
                                            .multilineTextAlignment(.leading)
                                        
                                        Divider()
                                        
                                        Text(room.isActive ? "활성화" : "비활성화")
                                            .minimumScaleFactor(0.5)
                                            .frame(width: 90, alignment: .leading)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .font(.title3)
                                    .foregroundStyle(room == selectedRoom ? Color.pointColor : Color(uiColor: .label))
                                    .padding(10)
                                }
                            }
                        }
                    }
                    // .padding(.horizontal, 30)
                }
                .listStyle(.inset)
                .overlay {
                    RoundedRectangle(cornerRadius: Constants.commonRadius)
                    // TODO: 색상 공통으로 쓰기
                        .stroke(Color.gray, lineWidth: 1.0)
                }
                .onTapGesture(count: 2, perform: {
                    withAnimation{
                        pickGroupId = nil
                    }
                })
                
                if let selectedRoom {
                    VStack(spacing: 0) {
                        HStack {
                            Text("모임 정보")
                            
                            Spacer()
                            
                            Text("활성화")
                            
                            Toggle(isOn: $isActive) {
                                
                            }
                            .frame(width: 50)
                        }
                        .padding(.bottom, 5)
                        .padding(.horizontal, 10)
                        
                        List {

                            
                            Section {
                                Text("\(selectedRoom.content)")
                            } header: {
                                Text("모임 소개")
                            }
                            
                            Section {
                                Text(selectedRoom.isOnline ? "위치 정보" : "플랫폼 정보")
                            } header: {
                                Text(selectedRoom.isOnline ? "위치" : "플랫폼")
                            }
                            
                            LabeledContent("카테고리", value: selectedRoom.category)
                            LabeledContent("종료시간", value: "종료시간")
                            LabeledContent("인원제한", value: "\(selectedRoom.limitPeople)")
                            LabeledContent("방장 ID", value: "\(selectedRoom.leaderID)")
                            LabeledContent("시간", value: "\(selectedRoom.date)")
                            
//                            Section {
//                                Text("\(selectedRoom.id)")
//                            } header: {
//                                Text("ID")
//                            }
//                            Section {
//                                Text("\(selectedRoom.date)")
//                            } header: {
//                                Text("시간")
//                            }
//                            Section {
//                                Text("\(selectedRoom.leaderID)")
//                            } header: {
//                                Text("방장")
//                            }
//                            
//                            Section {
//                                Text("\(selectedRoom.limitPeople)")
//                            } header: {
//                                Text("인원 제한")
//                            }
//                            
//                            Section {
//                                Text("종료 시간")
//                            } header: {
//                                Text("종료 시간")
//                            }
//                            
//                            Section {
//                                Text("\(selectedRoom.category)")
//                            } header: {
//                                Text("카테고리")
//                            }
                        }
                        .padding(.bottom, 30)
                        .listStyle(.inset)
                        .listRowSeparator(.hidden)
                        .overlay(
                            RoundedRectangle(cornerRadius: Constants.commonRadius)
                                .stroke(Color.gray, lineWidth: 1.0)
                                .padding(.bottom, 20)
                        )
                        
                        HStack {
                            Text("참여자 정보")
                            Spacer()
                        }
                        .padding(.leading, 10)
                        .padding(.bottom, 10)
                        
                        RoundedRectangle(cornerRadius: Constants.commonRadius)
                            .stroke(Color.gray, lineWidth: 1.0)
                    }
                    .frame(width: 300)
                }
            }
        }
        .padding(20)
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
