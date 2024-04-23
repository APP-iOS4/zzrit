//
//  SearchTextField.swift
//  ZzritConsumer
//
//  Created by SunJoon Lee on 4/23/24.
//

import SwiftUI

import ZzritKit

struct SearchTextField: View {
    
    // MARK: - binding properties
    
    // 검색 결과에 대한 뷰 모델
    @StateObject var searchViewModel: SearchViewModel
    // 오프라인 시 시트를 띄울 불리언 변수
    @State private var isSheetOn: Bool = false
    // 필터 변수
    @Binding var filterModel: FilterModel
    // 포커스
    @FocusState private var isFocused: Bool
    // 텍스트 필드가 Focused 됐는지 확인하는 변수
    @Binding var isTextFieldFocused: Bool
    
    // MARK: - stored properties
    
    private let historyViewModel: HistoryViewModel = HistoryViewModel.shared
    
    // MARK: - computed properties
    
    // 리셋 버튼
    private var resetButtonColor: Color {
        if filterModel.isFiltered {
            return Color.pointColor
        } else {
            return Color.staticGray4
        }
    }
    
    // MARK: - body
    
    var body: some View {
        // 검색 텍스트
        HStack(spacing: 15.0) {
            if #available(iOS 17.0, *) {
                TextField("검색어를 입력하세요.", text: $filterModel.searchText)
                    .focused($isFocused)
                    .onChange(of: isFocused) { _, newValue in
                        isTextFieldFocused = isFocused
                    }
            } else {
                TextField("검색어를 입력하세요.", text: $filterModel.searchText)
                    .focused($isFocused)
                    .onChange(of: isFocused) { newValue in
                        isTextFieldFocused = isFocused
                    }
            }
            
            // 글자가 입력 되었을 때 취소하고 텍스트를 삭제하는 버튼
            if !filterModel.searchText.isEmpty {
                Button {
                    filterModel.searchText = ""
                } label: {
                    Label("검색 취소", systemImage: "xmark.circle.fill")
                        .labelStyle(.iconOnly)
                        .foregroundStyle(Color.black)
                }
            }
            // 검색 결과로 이동하는 버튼
            Button {
                historyViewModel.save(filterModel.searchText)
                endTextEditing()
//                searchViewModel.loadRoom(filterModel.searchText)
            } label: {
                Label("검색", systemImage: "magnifyingglass")
                    .labelStyle(.iconOnly)
                    .foregroundStyle(Color.black)
            }
        }
        .padding()
        .onTapGesture {
            self.endTextEditing()
        }
        
        Divider()
        
        // 필터 스크롤
        ScrollView(.horizontal) {
            HStack(spacing: 10.0) {
                // 초기화 버튼
                Button {
                    filterModel.resetValues()
                } label: {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .resizable()
                        .scaledToFit()
                }
                .foregroundStyle(resetButtonColor)
                
                locationFilterPicker
                    .sheet(isPresented: $isSheetOn) {
                        VStack(spacing: 20.0) {
                            Button("확인") {
                                isSheetOn = false
                            }
                        }
                    }
                
                // 카테고리 피커
                CustomFilterPicker("카테고리", data: CategoryType.allCases, selection: $filterModel.categorySelection)
                // 모임 날짜 피커
                CustomFilterPicker("모임 날짜", data: DateType.allCases, selection: $filterModel.dateSelection)
            }
            .lineLimit(2)
            .padding(Configs.paddingValue)
            .fixedSize(horizontal: true, vertical: true)
        }
    }
}

extension SearchTextField {
    
    // MARK: - computed properties
    
    // 현재 위치 이름값
    private var locateSelectionText: String {
        if filterModel.isOnline == nil {
            return "위치"
        } else if filterModel.isOnline == true {
            return "온라인"
        } else {
            return filterModel.locationString
        }
    }
    
    var locationFilterPicker: some View {
        Menu {
            // 온라인 버튼
            if filterModel.isOnline != true {
                Button {
                    filterModel.isOnline = true
                } label: {
                    Text("온라인")
                }
            }
            
            Button {
                filterModel.isOnline = false
                filterModel.locationString = "어떤 위치"
                isSheetOn = true
            } label: {
                Text("오프라인")
            }
            
        } label: {
            Label(locateSelectionText, systemImage: "scope")
                .foregroundStyle(filterModel.isOnline != nil ? Color.pointColor : Color.primary)
                .padding(EdgeInsets(top: 5.0, leading: 10.0, bottom: 5.0, trailing: 15.0))
                .background {
                    RoundedRectangle(cornerRadius: Configs.cornerRadius)
                        .strokeBorder(filterModel.isOnline != nil ? Color.pointColor : Color.staticGray4,
                                      lineWidth: 1.0)
                        .background {
                            RoundedRectangle(cornerRadius: Configs.cornerRadius)
                                .fill(filterModel.isOnline != nil ? Color.lightPointColor : Color.white)
                            // FIXME: - 다크모드하면 fill의 Color.white를 바꿔야 함.
                        }
                }
        }
    }
}

#Preview {
    SearchTextField(searchViewModel: SearchViewModel(), filterModel: .constant(FilterModel()), isTextFieldFocused: .constant(false))
}
