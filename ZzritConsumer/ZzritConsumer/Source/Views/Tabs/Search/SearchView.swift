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
    @StateObject private var searchViewModel = SearchViewModel()
    
    @Binding var offlineLocation: OfflineLocationModel?
    
    @Environment(\.offlineLocation) private var sampleOfflineLocation
    
    var body: some View {
        SearchTextField(searchViewModel: searchViewModel, filterModel: $filterModel, isTextFieldFocused: $isTextFieldFocused)
            .onTapGesture {
                self.endTextEditing()
            }
            .toolbarBackground(.white, for: .tabBar)
        
        if isTextFieldFocused {
            HistoryView(searchText: $filterModel.searchText)
        } else {
            ResultRoomListView(searchViewModel: searchViewModel, filterModel: $filterModel, offlineLocation: $offlineLocation)
                .onTapGesture {
                    self.endTextEditing()
                }
        }
    }
}

#Preview {
    SearchView(offlineLocation: .constant(nil))
}
