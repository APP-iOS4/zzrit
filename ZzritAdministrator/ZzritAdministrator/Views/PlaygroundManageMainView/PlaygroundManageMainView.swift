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
    
    // TODO: 더미 데이터 -> 찐 데이터로 교체 해야함
    @State private var pickGroupId: DummyRoom.ID? = nil
    private var dummyData = DummyRoom.dummyRooms
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack {
                SearchField(action: {
                    print("검색")
                })
                
                Button {
                    
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(width: 30)
                }
                .padding(.horizontal)
            }
            HStack(spacing: 20) {
                Table(dummyData, selection: $pickGroupId) {
                    TableColumn("모임명", value: \.title)
                    TableColumn("인원/총인원", content: { group in
                        Text("\(group.limitPeople)")
                    })
                    // TODO: 데이트 포매터 모델에서 처리하는지 물어보기
                    TableColumn("날짜", value: \.date)
                    TableColumn("활성화", content: { group in
                        if group.isRemoved == true {
                            Text("활성화")
                        } else {
                            Text("비활성화")
                        }
                    })
                }
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
                // TODO: 무슨 로직인지 물어보기
//                if (pickGroupId != nil) {
//                    NewPlaygroundModalView(pickGroupId: $pickGroupId)
//                        .frame(width: 350)
//                }
                
                VStack(spacing: 0) {
                    HStack {
                        Text("모임 정보")
                        
                        Spacer()
                        
                        Text("활성화")
                        
                        Toggle(isOn: .constant(true)) {
                            
                        }
                        .frame(width: 50)
                    }
                    .padding(.bottom, 5)
                    .padding(.horizontal, 10)
                    
                    RoundedRectangle(cornerRadius: Constants.commonRadius)
                        .stroke(Color.gray, lineWidth: 1.0)
                        .padding(.bottom, 20)
                    
                    
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
            HStack {
                Spacer()
                
                Button {
                    Task {
                      //  try await data.loadPlayground()
                    }
                } label: {
                    // StaticTextView(title: "데이터 추가하기", width: 300.0, isActive: .constant(false))
                }
            }
        }
        .padding(20)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    PlaygroundManageMainView()
}

// TODO: 더미 데이터 입니다 추후 삭제할 예정입니다.
struct DummyRoom: Identifiable {
    /// 모임 제목
    public var title: String
    
    /// 카테고리
    private var category: String
    
    /// 모임 아이디 (PK)
    public var id: String = UUID().uuidString
    /// 모임장 아이디
    public var leaderID: String
    
    /// 모임 비활성화 여부
    public var isActive: Bool? = true
    
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
        DummyRoom(title: "더미 모임", category: "운동", leaderID: "leaderID.string", content: "모임 설명입니다. 설명입니다. 설설서럿ㄹ 명명명몀ㅇ", isOnline: false, time: "12시 20분", limitPeople: 12),
        
        DummyRoom(title: "온라인 더미 모임", category: "운동", leaderID: "leaderID.string", content: "모임 설명입니다. 설명입니다. 설설서럿ㄹ 명명명몀ㅇ", isOnline: true, time: "12시 20분", limitPeople: 12)
    ]
}
