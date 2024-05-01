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
                .onTapGesture {
                    endTextEditing()
                }
            
            if isTextFieldFocused {
                HistoryView(searchText: $filterModel.title, filterModel: $filterModel, searchViewModel: searchViewModel)
            } else {
                ResultRoomListView(searchViewModel: searchViewModel, filterModel: $filterModel, offlineLocation: $offlineLocation)
                    .onTapGesture {
                        endTextEditing()
                    }
            }
        }
    }
}

#Preview {
    SearchView(searchViewModel: SearchViewModel())
}
