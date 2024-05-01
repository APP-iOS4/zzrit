//
//  HistoryView.swift
//  ZzritConsumer
//
//  Created by SunJoon Lee on 4/23/24.
//

import SwiftUI

struct HistoryView: View {
    // 검색 기록 뷰모델
    @StateObject var historyViewModel: HistoryViewModel = HistoryViewModel.shared
    // 검색 기록 지울지 확인하는 Alert
//    @State private var isShowingAlert: Bool = false
    // 검색어
    @Binding var searchText: String
    // 필터 변수
    @Binding var filterModel: FilterModel
    // 검색 결과에 대한 뷰 모델
    @StateObject var searchViewModel: SearchViewModel
    
    // MARK: - body
    
    var body: some View {
        HStack {
            // 최근 검색어 타이틀
            Text("최근 검색어")
                .font(.title2)
                .fontWeight(.bold)
            Spacer()
            // 전체 검색어 삭제 버튼
            removeAllHistoriesButton
        }
        .padding(.horizontal, Configs.paddingValue)
        .onAppear {
            historyViewModel.load()
        }
        
        if historyViewModel.histories.count <= 0 {
            VStack {
                Spacer()
                Text("검색 기록이 없습니다.")
                Spacer()
            }
        } else {
            // 최근 검색어를 리스트 형태로 호출
            List {
                ForEach(historyViewModel.histories.reversed(), id: \.self) { history in
                    // 최근 검색 셀
                    historyCellButton(history)
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .padding(.bottom, 50.0)
        }
    }
    
    // 전체 검색어 삭제 버튼
    var removeAllHistoriesButton: some View {
        Button {
//            isShowingAlert.toggle()
            historyViewModel.removeAll()
        } label: {
            Text("전체삭제")
                .foregroundStyle(Color.staticGray2)
        }
//        // 삭제 경고창
//        .alert("검색기록 전체 삭제", isPresented: $isShowingAlert) {
//            // 검색기록 전체삭제
//            Button {
//                //historyViewModel.removeAll()
//                print("전체삭제 버튼 눌림")
//            } label: {
//                Label("전체 삭제", systemImage: "trash")
//                    .labelStyle(.titleOnly)
//            }
//        } message: {
//            Text("정말 검색 기록을 전체 삭제하시겠습니까?")
//        }
        .disabled(historyViewModel.histories.count > 0 ? false : true)
    }
    
    // 검색 기록 셀
    @ViewBuilder
    func historyCellButton(_ history: String) -> some View {
        Button {
            // 검색창 텍스트를 현재 누른 검색 기록으로 변경
            filterModel.title = history
            searchText = filterModel.title
            searchViewModel.getFilter(with: filterModel)
            endTextEditing()
            print("검색 기록 버튼 눌림")
            
        } label: {
            HStack(spacing: 20.0) {
                // 검색 돋보기 이미지
                Image(systemName: "magnifyingglass.circle.fill")
                    .foregroundStyle(Color.pointColor)
                // 검색 기록 내용
                Text(history)
                    .lineLimit(1)
                Spacer()
                // 현재 검색 기록 삭제 버튼
                Button {
                    historyViewModel.remove(history)
                } label: {
                    Label("검색기록 삭제", systemImage: "xmark")
                        .labelStyle(.iconOnly)
                }
                .foregroundStyle(.black)
            }
        }
    }
}

#Preview {
    HistoryView(searchText: .constant(""), filterModel: .constant(FilterModel()), searchViewModel: SearchViewModel())
}
