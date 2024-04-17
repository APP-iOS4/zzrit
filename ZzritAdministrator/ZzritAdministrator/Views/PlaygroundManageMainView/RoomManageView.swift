//
//  PlaygroundManageMainView.swift
//  ZzritAdministrator
//
//  Created by Healthy on 4/8/24.
//

import SwiftUI
import ZzritKit

struct RoomManageView: View {
    // 모임 뷰모델
    @EnvironmentObject private var roomViewModel: RoomViewModel
    
    // 선택된 모임
    @State private var selectedRoom: RoomModel? = nil
    
    @State private var showRoomDetail: Bool = false
    
    // 데이트 서비스
    private var dateService = DateService.shared
    
    @State private var roomStatus: ActiveType = .activation
    @State private var saerchText: String = ""
    
    // TODO: 뷰 뷴리는 로그인 뷰부터 짜고(급해서) 진행하겠습니다
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            // 상단 검색 & 필터
            HStack {
                RoomStatusPickerView(status: $roomStatus)
                RoomSearchField(searchText: $saerchText)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.staticGray3, lineWidth: 1.0)
            }
            
            // 모임 목록 및 정보들
            HStack(spacing: 20) {
                ScrollView {
                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                        Section(header: RoomSectionHeader()) {
                            ForEach(roomStatus == .activation ? roomViewModel.rooms.filter { $0.status == ActiveType.activation } : roomViewModel.rooms.filter { $0.status == ActiveType.deactivation }) { room in
                                
                                Button {
                                    selectedRoom = room
                                } label: {
                                    RoomCellView(room: room, selectedRoom: selectedRoom)
                                }
                            }
                            
                            // 패치를 위한 버튼
                            Button("") { }
                                .onAppear {
                                    roomStatus == .activation ? roomViewModel.loadRooms() : roomViewModel.loadDeactivateRooms()
                                }
                        }
                    }
                }
                .overlay {
                    RoundedRectangle(cornerRadius: Constants.commonRadius)
                        .stroke(Color.staticGray3, lineWidth: 1.0)
                }
            }
            
            // 모임 관리 버튼
            MyButton(named: "선택한 모임 관리") {
                if selectedRoom != nil {
                    showRoomDetail.toggle()
                }
            }
           .frame(maxWidth: .infinity, alignment: .bottomTrailing)
        }
        .padding(20)
        .fullScreenCover(isPresented: $showRoomDetail, content: {
            // 버튼 단계에서 nil일 시 동작하지 않도록 에러처리를 했기 때문에 포스 언래핑
            RoomDetailView(room: selectedRoom!)
        })
    }
}

#Preview {
    RoomManageView()
        .environmentObject(RoomViewModel())
}

struct RoomStatusPickerView: View {
    @Binding var status: ActiveType
    
    var body: some View {
        Picker("\(status)", selection: $status){
            Text("활성화").tag(ActiveType.activation)
            Text("비활성화").tag(ActiveType.deactivation)
        }
        .pickerStyle(.menu)
        .tint(Color.pointColor)
    }
}

struct RoomSearchField: View {
    @Binding var searchText: String
    
    var body: some View {
        TextField("문의 내용을 입력해주세요.", text: $searchText)
            .padding(10.0)
            .padding(.leading)
        Button {
            print("검색!")
        } label: {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.white)
                .padding()
                .background(Color.pointColor)
                .clipShape(UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomTrailing: 10, topTrailing: 10)))
        }
    }
}

struct RoomCellView: View {
    var room: RoomModel
    var selectedRoom: RoomModel?
    
    // 데이트 서비스
    var dateService = DateService.shared
    
    var body: some View {
        HStack {
            Text(room.title)
                .frame(minWidth: 100, alignment: .leading)
                .multilineTextAlignment(.leading)
            Spacer()
            
            Divider()
            
            Text("\(room.limitPeople)")
                .frame(width: 90, alignment: .leading)
            
            Divider()
            
            Text(dateService.formattedString(date: room.dateTime, format: "MM/dd HH:mm"))
                .frame(width: 120, alignment: .leading)
                .multilineTextAlignment(.leading)
            
            Divider()
            
            Text(room.status == ActiveType.activation ? "활성화" : "비활성화")
                .frame(width: 90, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
        .font(.title3)
        .foregroundStyle(room.id == selectedRoom?.id ? Color.pointColor : Color.primary)
        .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
    }
}
