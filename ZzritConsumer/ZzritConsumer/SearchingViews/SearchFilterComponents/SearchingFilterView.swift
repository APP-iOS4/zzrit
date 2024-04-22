//
//  SearchingFilterView.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/8/24.
//

import SwiftUI

// 모임 방식에 대한 임시 enum
enum RoomProcedureMethod: String {
    case all = "전체"
    case online = "온라인"
    case offline = "오프라인"
}

// 날짜 피커를 위한 임시 Enum
enum DatePickerEnum: String, CaseIterable {
    case today = "오늘 (4월 5일)"
    case tomorrow = "내일 (4월 6일)"
    case dayAfterTomorrow = "모레 (4월 7일)"
}

// 카테고리 피커를 위한 임시 Enum
enum CategoryPickerEnum: String, CaseIterable, Hashable {
    case all = "전체"
    case trip = "여행"
    case category1
    case category2
    case category3
    case category4
    case category5
    case category6
    
    static var allRaws: [String] {
        return CategoryPickerEnum.allCases.map {$0.rawValue}
    }
}

struct SearchingFilterView: View {
    
    @State private var selectedMethod: RoomProcedureMethod = .all
    @State private var selectedDate: DatePickerEnum = .today
    @State private var selectedCategory: CategoryPickerEnum = .all
    
    var body: some View {
        VStack {
            HStack(spacing: 15.0) {
                ProcedureSelectButton(
                    selectedMethod: $selectedMethod,
                    procedureMethod: .all
                )
                
                ProcedureSelectButton(
                    selectedMethod: $selectedMethod,
                    procedureMethod: .offline
                )
                
                ProcedureSelectButton(
                    selectedMethod: $selectedMethod,
                    procedureMethod: .online
                )
                
                Spacer()
            }
            .padding(.bottom, 10.0)
            
            if selectedMethod == .offline {
                HStack {
                    Text("위치")
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button {
                        // TODO: 위치 검색 뷰 네비게이션 구현 필요
                        print("위치 검색 뷰 이동 버튼 눌림")
                    } label: {
                        Label("위치를 설정해주세요", systemImage: "location")
                            .labelStyle(/*@START_MENU_TOKEN@*/DefaultLabelStyle()/*@END_MENU_TOKEN@*/)
                            .foregroundStyle(Color.pointColor)
                    }
                }
                .padding(.bottom, 10)
            } else if selectedMethod == .online {
                HStack {
                    Text("플랫폼")
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button {
                        // TODO: 위치 검색 뷰 네비게이션 구현 필요
                        print("위치 검색 뷰 이동 버튼 눌림")
                    } label: {
                        Label("위치를 설정해주세요", systemImage: "location")
                            .labelStyle(/*@START_MENU_TOKEN@*/DefaultLabelStyle()/*@END_MENU_TOKEN@*/)
                            .foregroundStyle(Color.pointColor)
                    }
                }
                .padding(.bottom, 10)
            }
            
            HStack {
                Text("모임 날짜")
                    .fontWeight(.bold)
                
                Spacer()
                
                Picker("모임 날짜", selection: $selectedDate) {
                    ForEach(DatePickerEnum.allCases, id: \.self) { date in
                        Text("\(date.rawValue)")
                    }
                }
                .pickerStyle(.menu)
                .tint(.pointColor)
                .padding([.horizontal], -20.0)
            }
            
            HStack {
                Text("카테고리")
                    .fontWeight(.bold)
                
                Spacer()
                
                Picker("카테고리", selection: $selectedDate) {
                    ForEach(CategoryPickerEnum.allCases, id: \.self) { category in
                        Text("\(category.rawValue)")
                    }
                }
                .pickerStyle(.menu)
                .tint(.pointColor)
                .padding([.horizontal], -20.0)
            }
        }
        .padding()
        .background {
            Color.staticGray6
                .ignoresSafeArea(edges: .bottom)
        }
    }
}

#Preview {
//    SearchingFilterView()
    SearchingView()
}
