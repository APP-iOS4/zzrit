//
//  ResultRoomListView.swift
//  ZzritConsumer
//
//  Created by SunJoon Lee on 4/23/24.
//

import SwiftUI

struct ResultRoomListView: View {
    
    @StateObject var searchViewModel: SearchViewModel
    @Binding var filterModel: FilterModel
    @Binding var offlineLocation: OfflineLocationModel?
    
    var body: some View {
        // 검색 결과
        ScrollView(.vertical) {
            LazyVStack {
                ForEach(searchViewModel.filterRooms) { room in
                    // 모임 리스트 셀 불러오기
                    NavigationLink {
                        // 상세페이지 뷰 연결
                        RoomDetailView(room: room)
                    } label: {
                        RoomCellView(room: room)
                    }
                }
                
                // 아래로 내렸을 때, 새로 불러오는 함수
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.clear)
                    .onAppear {
                        searchViewModel.loadRooms(filterModel: filterModel, offlineLocation: offlineLocation)
                        searchViewModel.deactivateRooms()
                        searchViewModel.getFilter(with: filterModel)
                    }
            }
            .padding(.top, 10.0)
            .padding(.horizontal, Configs.paddingValue)
            .padding(.bottom, 80)   // 윤호에게 bottom 80준 이유 물어보기
        }
        .refreshable {
            searchViewModel.refreshRooms(with: filterModel, offlineLocation: offlineLocation)
        }
        
        Rectangle()
            .frame(height: 1)
            .foregroundStyle(.clear)
    }
}

#Preview {
    ResultRoomListView(searchViewModel: SearchViewModel(), filterModel: .constant(FilterModel()), offlineLocation: .constant(nil))
}
