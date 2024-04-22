//
//  OfflineSearchHistoryView.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/21/24.
//

import SwiftUI

struct OfflineSearchHistoryView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var histories: [OfflineLocationModel] = []
    
    var body: some View {
        ZStack {
            if histories.isEmpty {
                VStack {
                    Image("ZziritLogoImage")
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(width: 250)
                    Text("검색 기록이 없어요.")
                }
            } else {
                VStack {
                    HStack {
                        Text("검색기록")
                            .font(.title3.bold())
                        
                        Spacer()
                        
                        Button("전체삭제") {
                            LocalStorage.shared.clearHistory()
                            histories.removeAll()
                        }
                        .tint(.secondary)
                    }
                    .padding(Configs.paddingValue)
                    
                    List {
                        ForEach(histories) { history in
                            OfflineLocationHistoryCell(locationModel: history)
                                .onTapGesture {
                                    selectHistory(history)
                                }
                        }
                        .onDelete { indexSet in
                            deleteRow(indexSet)
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                }
            }
        }
        .onAppear {
            fetchHistory()
        }
    }
    
    private func fetchHistory() {
        histories = LocalStorage.shared.locationHistories()
    }
    
    private func deleteRow(_ indexSet: IndexSet) {
        if let firstIndex = indexSet.first {
            LocalStorage.shared.deleteHistory(at: firstIndex)
        }
    }
    
    private func selectHistory(_ history: OfflineLocationModel) {
        dismiss()
    }
}

#Preview {
    OfflineSearchHistoryView()
}
