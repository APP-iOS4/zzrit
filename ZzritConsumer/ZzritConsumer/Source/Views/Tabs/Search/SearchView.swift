//
//  SearchView.swift
//  ZzritConsumer
//
//  Created by SunJoon Lee on 4/23/24.
//

import SwiftUI

struct SearchView: View {
    @State private var filterModel: FilterModel = FilterModel()
    @State private var isTextFieldFocused: Bool = false
    @StateObject var searchViewModel: SearchViewModel = SearchViewModel()
    @State private var offlineLocation: OfflineLocationModel?
    
    var body: some View {
        VStack {
            SearchTextField(searchViewModel: searchViewModel, filterModel: $filterModel, offlineLocation: $offlineLocation, isTextFieldFocused: $isTextFieldFocused)
                .toolbarBackground(.white, for: .tabBar)
            
            if isTextFieldFocused {
                HistoryView(searchText: $filterModel.title)
            } else {
                ResultRoomListView(searchViewModel: searchViewModel, filterModel: $filterModel, offlineLocation: $offlineLocation)
            }
        }
        .onTapGesture {
            self.endTextEditing()
//            searchViewModel.refreshRooms(with: filterModel, offlineLocation: offlineLocation)
        }
    }
}

#Preview {
    SearchView(searchViewModel: SearchViewModel())
}
