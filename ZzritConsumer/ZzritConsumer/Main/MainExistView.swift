//
//  MainView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/8/24.
//

import SwiftUI

struct MainExistView: View {
    @StateObject private var loadRoomViewModel: LoadRoomViewModel = LoadRoomViewModel()
    @Binding var isOnline: Bool
    // @State private var fetchCount: Int = 0
    
    var body: some View {
        if #available(iOS 17.0, *) {
            LazyVStack(alignment: .leading) {
                let _ = print("\(isOnline)")
                // 모임 리스트 타이틀
                Text("최근 생성된 모임")
                    .modifier(SubTitleModifier())
                
                ForEach(loadRoomViewModel.filterRooms) { room in
                    // 모임 리스트 셀 불러오기
                    NavigationLink {
                        // 상세페이지 뷰 연결
                        RoomDetailView(room: room)
                    } label: {
                        RoomCellView(room: room)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                
                // 아래로 내렸을 때, 새로 불러오는 함수
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.clear)
                    .onAppear {
                        loadRoomViewModel.consumerLoadRoom()
                        loadRoomViewModel.deactivateRooms()
                        loadRoomViewModel.getFilter(isOnline: isOnline)
                    }
            }
            .padding(.bottom, 80)
            .onChange(of: isOnline) {
                loadRoomViewModel.getFilter(isOnline: isOnline)
            }
        } else {
            LazyVStack(alignment: .leading) {
                let _ = print("\(isOnline)")
                // 모임 리스트 타이틀
                Text("최근 생성된 모임")
                    .modifier(SubTitleModifier())
                
                ForEach(loadRoomViewModel.filterRooms) { room in
                    // 모임 리스트 셀 불러오기
                    NavigationLink {
                        // 상세페이지 뷰 연결
                        RoomDetailView(room: room)
                    } label: {
                        RoomCellView(room: room)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.clear)
                    .onAppear {
                        Task {
                            loadRoomViewModel.consumerLoadRoom()
                            loadRoomViewModel.deactivateRooms()
                            loadRoomViewModel.getFilter(isOnline: isOnline)
                        }
                    }
            }
            .padding(.bottom, 80)
            .onChange(of: isOnline) { newValue in
                loadRoomViewModel.getFilter(isOnline: isOnline)
            }
        }
    }
}

#Preview {
    MainExistView(isOnline: .constant(false))
}
