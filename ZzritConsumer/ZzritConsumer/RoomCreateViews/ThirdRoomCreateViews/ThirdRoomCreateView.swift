//
//  ThirdRoomCreateView.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/9/24.
//

import SwiftUI

import ZzritKit

struct ThirdRoomCreateView: View {
    @State var isOnline: Bool?
    @State var platformSelection: PlatformType?
    @State var dateNumber: Int?
    // 버튼 활성화 여부를 결정할 변수
    @State var isButtonEnabled: Bool = false
    
    var body: some View {
        NavigationStack {
            // 커스텀 네비게이션 바 - 두 번째 페이지
            RCNavigationBarView(page: .third)
                .padding()
            
            VStack {
                ScrollView {
                    // 진행방식을 입력 받는 뷰
                    VStack {
                        RCProcedurePicker(
                            isOnline: $isOnline,
                            platformSelection: $platformSelection,
                            onPressButton: checkButtonEnable)
                    }
                    .padding(.bottom)
                    
                    // 시간을 입력 받는 뷰
                    VStack {
                        RoomCreateSubTitle("시간")
                        
                        // 날짜 선택 버튼
                        HStack {
                            SelectionButtonView(title: "22일 (금)", data: 0, selection: $dateNumber, padding: 5.0) {
                                
                            }
                            SelectionButtonView(title: "23일 (토)", data: 1, selection: $dateNumber, padding: 5.0) {
                                
                            }
                            SelectionButtonView(title: "24일 (일)", data: 2, selection: $dateNumber, padding: 5.0) {
                                
                            }
                        }
                        
                        // 시간, 분 선택 버튼
                        RCTimeSettingView()
                    }
                    .padding(.vertical)
                    
                    // 정원 선택 화면
                    VStack {
                        RoomCreateSubTitle("정원", clarification: "2~10명")
                        Spacer()
                        
                    }
                    .padding(.vertical)
                }
                
                // 다음으로 넘어가기 버튼
                GeneralButton(isDisabled: !isButtonEnabled, "완료",tapAction: {
                    
                })
            }
            .padding()
        }
    }
    
    func checkButtonEnable() {
        
    }
}

#Preview {
    ThirdRoomCreateView()
}
