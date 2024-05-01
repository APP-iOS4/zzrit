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
    
    @EnvironmentObject var locationService: LocationService
    
    // 검색 결과에 대한 뷰 모델
    @StateObject var searchViewModel: SearchViewModel
    // 필터 변수
    @Binding var filterModel: FilterModel
    // 위치 검색 변수
    @Binding var offlineLocation: OfflineLocationModel?
    // 포커스
    @FocusState private var isFocused: Bool
    // 텍스트 필드가 Focused 됐는지 확인하는 변수
    @Binding var isTextFieldFocused: Bool
    // 위치 검색 시트 변수
    @State private var isLocationSheetOn: Bool = false
    
    // MARK: - stored properties
    
    private let historyViewModel: HistoryViewModel = HistoryViewModel.shared
    
    // MARK: - body
    
    var body: some View {
        // 검색 텍스트
        HStack(spacing: 15.0) {
            TextField("검색어를 입력하세요.", text: $filterModel.title)
                .focused($isFocused)
                .customOnChange(of: isFocused) { _ in
                    isTextFieldFocused = isFocused
                }
            
            // 글자가 입력 되었을 때 취소하고 텍스트를 삭제하는 버튼
            if !filterModel.title.isEmpty {
                Button {
                    filterModel.title = ""
                } label: {
                    Label("검색 취소", systemImage: "xmark.circle.fill")
                        .labelStyle(.iconOnly)
                        .foregroundStyle(Color.black)
                }
            }
            // 검색 결과로 이동하는 버튼
            Button {
                historyViewModel.save(filterModel.title)
                searchViewModel.getFilter(with: filterModel)
                endTextEditing()
            } label: {
                Label("검색", systemImage: "magnifyingglass")
                    .labelStyle(.iconOnly)
                    .foregroundStyle(Color.black)
            }
        }
        .padding()
        
        Divider()
        
        // 필터 스크롤
        ScrollView(.horizontal) {
            HStack(spacing: 10.0) {
                if filterModel.isFiltered {
                    // 초기화 버튼
                    Button {
                        filterModel.resetValues()
                        offlineLocation = nil
                    } label: {
                        Image(systemName: "arrow.counterclockwise.circle.fill")
                            .resizable()
                            .scaledToFit()
                    }
                    .foregroundStyle(Color.staticGray4)
                }
                
                // 위치 피커
                locationFilterPicker
                    .sheet(isPresented: $isLocationSheetOn) {
                        OfflineLocationSearchView(searchType: .createRoom, offlineLocation: $offlineLocation)
                    }
                
                // 카테고리 피커
                CustomFilterPicker("카테고리", data: CategoryType.allCases, selection: $filterModel.category)
                // 모임 날짜 피커
                CustomFilterPicker("모임 날짜", data: DateType.allCases, selection: $filterModel.dateType)
            }
            .lineLimit(2)
            .padding(.horizontal, Configs.paddingValue)
            .padding(.vertical, 10.0)
            .fixedSize(horizontal: true, vertical: true)
        }
        .scrollIndicators(.hidden)
        .customOnChange(of: filterModel.isOnline) { _ in
            searchViewModel.refreshRooms(with: filterModel, offlineLocation: offlineLocation)
        }
        .customOnChange(of: offlineLocation) { _ in
            searchViewModel.refreshRooms(with: filterModel, offlineLocation: offlineLocation)
            print("오프라인 위치 바뀜")
        }
        .customOnChange(of: filterModel.dateType) { _ in
            searchViewModel.getFilter(with: filterModel)
        }
        .customOnChange(of: filterModel.category) { _ in
            searchViewModel.getFilter(with: filterModel)
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
            return offlineLocation?.address ?? "오프라인"
        }
    }
    
    var locationFilterPicker: some View {
        Menu {
            // 온라인 버튼
            if filterModel.isOnline != true {
                Button {
                    filterModel.isOnline = true
                    offlineLocation = nil
                } label: {
                    Text("온라인")
                }
            }
            Button {
                filterModel.isOnline = false
                isLocationSheetOn.toggle()
            } label: {
                Text(filterModel.isOnline == false ? "위치선택" : "오프라인")
            }
        } label: {
            Label(locateSelectionText, systemImage: "scope")
                .foregroundStyle(filterModel.isOnline != nil ? Color.pointColor : Color.primary)
                .padding(EdgeInsets(top: 5.0, leading: 10.0, bottom: 5.0, trailing: 15.0))
                .background {
                    RoundedRectangle(cornerRadius: Configs.cornerRadius)
                        .strokeBorder(filterModel.isOnline != nil ? Color.pointColor : Color.staticGray4, lineWidth: 1.0)
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
    SearchTextField(searchViewModel: SearchViewModel(), filterModel: .constant(FilterModel()), offlineLocation: .constant(nil), isTextFieldFocused: .constant(false))
}
