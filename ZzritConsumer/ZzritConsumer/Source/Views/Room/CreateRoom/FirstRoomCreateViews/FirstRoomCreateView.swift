//
//  FirstRoomCreateView.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/9/24.
//

import SwiftUI

import ZzritKit

// TODO: 카테고리를 선택해 달라는 빨간색 에러 문을 띄워준다.

struct FirstRoomCreateView: View {
    
    // MARK: - 저장 프로퍼티
    
    //    @EnvironmentObject var coordinator: Coordinator
    // 뷰모델
    let VM: RoomCreateViewModel = RoomCreateViewModel.shared
    
    @Environment(\.dismiss) private var topDismiss
    
    // 카테고리 선택 변수
    @State private var selection: CategoryType? = nil
    // 버튼 활성화 여부를 결정할 변수
    @State private var isButtonEnabled: Bool = false
    // 다음으로 넘어가기 변수
    @State private var isShowingNextButton: Bool = false
    // 그리드 열 상수 -> 두 줄
    let columns: [GridItem] = [
        GridItem(.flexible()), GridItem(.flexible())
    ]
    
    // MARK: - body
    
    var body: some View {
        /// 커스텀 네비게이션 바
        RCNavigationBar(page: .page1) {
            // 모임 카테고리 선택 부분 소제목
            VStack {
                RCSubTitle("모임 주제를 선택해주세요.")
                    .padding(.bottom, Configs.paddingValue)
            }
            // 스크롤 뷰
            ScrollView(.vertical) {
                // 모임 카테고리 그리드
                LazyVGrid(columns: columns) {
                    ForEach(CategoryType.allCases, id: \.self) { category in
                        PointSelectionButton(
                            category.rawValue,
                            data: category,
                            selection: $selection) {
                                checkButtonEnable()
                            }
                            .lineLimit(1)
                    }
                }
            }
            .scrollIndicators(.hidden)
            // 다음 화면으로 넘어갈 버튼
            GeneralButton("다음", isDisabled: !isButtonEnabled) {
                // VM에 선택한 카테고리 저장
                Configs.printDebugMessage(selection)
                VM.saveSelectedCategory(selection: selection)
                
                // 다음 화면으로 이동
                // coordinator.push(.newRoom(.page2))
                isShowingNextButton.toggle()
            }
            .navigationDestination(isPresented: $isShowingNextButton) {
                SecondRoomCreateView()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func checkButtonEnable() {
        if selection != nil {
            isButtonEnabled = true
        } else {
            isButtonEnabled = false
        }
    }
}

#Preview {
    NavigationStack {
        FirstRoomCreateView()
        //            .environmentObject(Coordinator())
    }
}
