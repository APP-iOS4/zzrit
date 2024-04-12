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
    @State var participantsLimit: Int = 2
    @State var gender: Bool?
    @State var dateNumber: Int?
    // 버튼 활성화 여부를 결정할 변수
    @State var isButtonEnabled: Bool = false
    @State var isStaticGuageLimit: Bool = false
    @State var staticGuageLimit: Double = 20.0
    
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
                                checkButtonEnable()
                            }
                            SelectionButtonView(title: "23일 (토)", data: 1, selection: $dateNumber, padding: 5.0) {
                                checkButtonEnable()
                            }
                            SelectionButtonView(title: "24일 (일)", data: 2, selection: $dateNumber, padding: 5.0) {
                                checkButtonEnable()
                            }
                        }
                        
                        // 시간, 분 선택 버튼
                        RCTimeSettingView()
                    }
                    .padding(.vertical)
                    
                    // 정원 선택 화면
                    RCParticipantsSection(participantsLimit: $participantsLimit)
                        .padding(.vertical)
                    
                    // 참여가능 성별
                    HStack(spacing: 10.0) {
                        RoomCreateSubTitle("성별", clarification: "선택")
                        Spacer()
                        GenderButton(data: true, selection: $gender) {
                            checkButtonEnable()
                        }
                        
                        GenderButton(data: false, selection: $gender) {
                            checkButtonEnable()
                        }
                    }
                    .padding(.vertical)
                    
                    // 참여 가능 정전기 지수
                    VStack(spacing: 20.0) {
                        HStack {
                            RoomCreateSubTitle("참여가능 정전기 지수", clarification: "\(Int(staticGuageLimit))W이상", type: .staticGuage)
                            
                            Toggle("", isOn: $isStaticGuageLimit)
                                .frame(width: 100.0)
                                .offset(x: -2.0)
                        }
                        
                        Slider(value: $staticGuageLimit, in: 1 ... 100, step: 1.0)
                    }
                    .padding(.vertical)
                }
                // 다음으로 넘어가기 버튼
                GeneralButton(isDisabled: !isButtonEnabled, "완료") {
                    print("새 모임 등록")
                }
            }
            .padding()
        }
    }
    
    func checkButtonEnable() {
        if isOnline != nil && dateNumber != nil && gender != nil {
            isButtonEnabled = true
        } else {
            isButtonEnabled = false
        }
    }
}

#Preview {
    ThirdRoomCreateView()
}
