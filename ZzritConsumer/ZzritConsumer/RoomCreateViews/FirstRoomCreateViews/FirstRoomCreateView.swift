//
//  FirstRoomCreateView.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/9/24.
//

import SwiftUI

// TODO: 카테고리를 선택해 달라는 빨간색 에러 문을 띄워준다.

struct FirstRoomCreateView: View {
    // 뷰모델
    let VM: RoomCreateViewModel
    
    // 카테고리 선택 변수
    @State var selection: FilterCategory? = nil
    // 버튼 활성화 여부를 결정할 변수
    @State var isButtonEnabled: Bool = false
    // 다음 뷰 이동 변수
    @State var isShowingNextView: Bool = false
    
    // 그리드 열 상수 -> 두 줄
    let columns: [GridItem] = [
        GridItem(.flexible()), GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            // 커스텀 네비게이션 바 - 첫 번째 페이지
            RCNavigationBarView(page: .first)
                .padding()
            
            VStack {
                ScrollView(.vertical) {
                    VStack {
                        // 모임 카테고리 선택 부분 소제목
                        RoomCreateSubTitle("모임 주제를 선택해주세요.")
                        
                        // 모임 카테고리 그리드
                        LazyVGrid(columns: columns, content: {
                            ForEach(FilterCategory.allCases, id: \.self) { category in
                                CategoryCellView(data: category, selection: $selection) {
                                    if selection != nil {
                                        isButtonEnabled = true
                                    }
                                }
                                .lineLimit(1)
                            }
                        })
                    }
                }
                
                Spacer()
                
                // 다음 화면으로 넘어갈 버튼
                GeneralButton("다음", isDisabled: !isButtonEnabled) {
                    // VM에 선택한 카테고리 저장
                    VM.saveSelectedCategory(selection: selection)
                    
                    // 다음 화면으로 이동
                    isShowingNextView.toggle()
                }
                .navigationDestination(isPresented: $isShowingNextView) {
                    SecondRoomCreateView(VM: VM)
                        .navigationBarBackButtonHidden(true)
                }
            }
            .padding()
        }
    }
}

#Preview {
    FirstRoomCreateView(VM: RoomCreateViewModel())
}
