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
    let VM: RoomCreateViewModel
    
    // 카테고리 선택 변수
    @State var selection: CategoryType? = nil
    // 버튼 활성화 여부를 결정할 변수
    @State var isButtonEnabled: Bool = false
    // 다음으로 넘어가기 변수
    @State var isShowingNextButton: Bool = false
    // 그리드 열 상수 -> 두 줄
    let columns: [GridItem] = [
        GridItem(.flexible()), GridItem(.flexible())
    ]
    
    // MARK: - body
    
    var body: some View {
        NavigationStack {
            /// 커스텀 네비게이션 바
            RCNavigationBar(page: .page1) {
                // 모임 카테고리 선택 부분 소제목
                RCSubTitle("모임 주제를 선택해주세요.")
                
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
                // 다음 화면으로 넘어갈 버튼
                GeneralButton("다음", isDisabled: !isButtonEnabled) {
                    // VM에 선택한 카테고리 저장
                    VM.saveSelectedCategory(selection: selection)
                    
                    // 다음 화면으로 이동
                    // coordinator.push(.newRoom(.page2))
                    isShowingNextButton.toggle()
                }
                .navigationDestination(isPresented: $isShowingNextButton) {
                    SecondRoomCreateView(VM: VM)
                }
            }
        }
    }
    
    func checkButtonEnable() {
        if selection != nil {
            isButtonEnabled = true
        }
    }
}

#Preview {
    NavigationStack {
        FirstRoomCreateView(VM: RoomCreateViewModel())
        //            .environmentObject(Coordinator())
    }
}
