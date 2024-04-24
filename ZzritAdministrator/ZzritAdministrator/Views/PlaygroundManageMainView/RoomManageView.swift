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
    // 모임 상세 페이지
    @State private var showRoomDetail: Bool = false
    // 모임 - 활성화/비활성화 상태
    @State private var roomStatus: RoomStatus = .all
    // 검색어
    @State private var searchText: String = ""
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            // 상단 검색 & 필터
            HStack {
                RoomStatusPickerView(status: $roomStatus)
                RoomSearchField(searchText: $searchText)
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
                            ForEach(filterRooms(status: roomStatus, searchText: searchText)) { room in
                                Button {
                                    selectedRoom = room
                                } label: {
                                    RoomCellView(room: room, selectedRoom: selectedRoom)
                                }
                            }
 
                            // 패치를 위한 버튼
                            Button("") { }
                                .onAppear {
                                    roomViewModel.loadRooms()
                                }
                        }
                    }
                }
                .refreshable {
                    roomViewModel.refreshRooms()
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
    
    func filterRooms(status: RoomStatus, searchText: String) -> [RoomModel] {
        switch status {
        case .all:
            return searchText.isEmpty ? roomViewModel.rooms : roomViewModel.rooms.filter { $0.title.contains(searchText) }
        case .activation:
            return searchText.isEmpty ? roomViewModel.rooms.filter { $0.status == ActiveType.activation } : roomViewModel.rooms.filter { $0.status == ActiveType.activation && $0.title.contains(searchText) }
        case .deactivation:
            return searchText.isEmpty ? roomViewModel.rooms.filter { $0.status == ActiveType.deactivation } : roomViewModel.rooms.filter { $0.status == ActiveType.deactivation && $0.title.contains(searchText) }
        }
    }
}

#Preview {
    RoomManageView()
        .environmentObject(RoomViewModel())
}

struct RoomStatusPickerView: View {
    @Binding var status: RoomStatus
    
    var body: some View {
        Picker("\(status)", selection: $status){
            Text("전체").tag(RoomStatus.all)
            Text("활성화").tag(RoomStatus.activation)
            Text("비활성화").tag(RoomStatus.deactivation)
        }
        .pickerStyle(.menu)
        .tint(Color.pointColor)
    }
}

struct RoomSearchField: View {
    // 모임 뷰모델
    @EnvironmentObject private var roomViewModel: RoomViewModel
    
    @Binding var searchText: String
    
    var body: some View {
        TextField("문의 내용을 입력해주세요.", text: $searchText)
            .padding(10.0)
            .padding(.leading)
        Button {
            roomViewModel.searchRooms(searchText: searchText)
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

enum RoomStatus: String {
    case all = "전체"
    case activation = "활성화"
    case deactivation = "비활성화"
}
