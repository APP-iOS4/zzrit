//
//  ThirdRoomCreateView.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/9/24.
//

import SwiftUI

import ZzritKit

struct ThirdRoomCreateView: View {
    
    // MARK: - 저장 프로퍼티
    
//    @EnvironmentObject var coordinator: Coordinator
    @EnvironmentObject var userService: UserService
    
    // 오프라인/온라인 선택 변수
    @State private var processSelection: RoomProcessType?
    
    let VM: RoomCreateViewModel

    @State private var placeLongitude: Double?
    @State private var placeLatitude: Double?
    // FIXME: 모임 위치 변수 -
    
    // 플랫폼 선택 변수
    @State private var platformSelection: PlatformType?
    // 날짜 선택 변수
    @State private var dateSelection: DateType?
    // 시간 선택 변수
    @State private var hourSelection: Int = Int(DateType.today.date.toStringHour()) ?? 0
    // 분 선택 변수
    @State private var minuteSelection: Int = Int(DateType.today.date.toStringMinute()) ?? 0
    // 참여자 수 제한 변수
    @State private var limitPeople: Int = 2
    // 성별 제한 선택 변수
    @State private var genderSelection: GenderType?
    // 정전기지수 제한이 있는지 없는지 선택하는 변수
    @State private var hasScoreLimit: Bool = false
    // 정전기지수 제한 값 - slider는 int 없음
    @State private var staticGuageLimit: Double = 20.0
    // 버튼 활성화 여부를 결정할 변수
    @State var isButtonEnabled: Bool = false
    
    // MARK: - 연산 프로퍼티
    
    var hourText: String {
        if 0 <= hourSelection && hourSelection < 12 {
            return "오전 \(hourSelection)"
        } else if 12 <= hourSelection && hourSelection < 24 {
            return "오후 \(hourSelection - 12)"
        } else {
            return ""
        }
    }
    
    var minuteText: String {
        if 0 <= minuteSelection && minuteSelection < 10 {
            return "0\(minuteSelection)"
        } else if 10 <= minuteSelection && minuteSelection < 60 {
            return "\(minuteSelection)"
        } else {
            return ""
        }
    }
    
    // MARK: - body
    
    var body: some View {
        RCNavigationBar(page: .page3) {
            ScrollView {
                // 진행방식을 입력 받는 뷰
                RCProcedurePicker(processSelection: $processSelection, platformSelection: $platformSelection) {
                    // 피커 버튼 눌렀을 때 사용할 함수
                    checkButtonEnable()
                }
<<<<<<< HEAD
                // 다음으로 넘어가기 버튼
                GeneralButton("완료", isDisabled: !isButtonEnabled) {
                    print("새 모임 등록")
=======
                
                // 시간을 입력 받는 뷰
                timeSelectionView
                    .padding(.bottom, Configs.paddingValue)
                
                // 정원 선택 화면
                RCParticipantsSection(participantsLimit: $limitPeople)
                    .padding(.bottom, Configs.paddingValue)
                
                // 성별 선택 화면
                genderSelectionView
                    .padding(.bottom, Configs.paddingValue)
                
                staticGuageLimitView
            }
            
            // 다음으로 넘어가기 버튼
            GeneralButton(isDisabled: !isButtonEnabled, "완료") {
                VM.saveRoomProcess(
                    processSelection: processSelection,
                    placeLatitude: placeLatitude,
                    placeLongitude: placeLongitude,
                    platform: platformSelection
                )
                
                VM.saveDateTime(
                    dateSelection: dateSelection,
                    hourSelection: hourSelection,
                    minuteSelection: minuteSelection
                )
                
                VM.saveGenderLimitation(genderLimitation: genderSelection)
                
                VM.saveScoreLimitation(
                    hasScoreLimit: hasScoreLimit,
                    scoreLimitation: staticGuageLimit
                )
                
                VM.saveLimitPeople(limitPeople: limitPeople)
                
                Task {
                    let result = try await VM.createRoom(userModel: userService.loginedUserInfo())
                    if result {
                        print("모임 추가 성공!")
                    }
>>>>>>> c6d61d4 (feat: 코디네이터 기본 틀과 모임 생성 뷰 리펙토링 및 이미지 / 시간 선택 외의 기능 완)
                }
            }
        }
    }
    
    func checkButtonEnable() {
        if processSelection != nil && dateSelection != nil {
            isButtonEnabled = true
        }
    }
}

extension ThirdRoomCreateView {
    // 날짜 선택 뷰
    var timeSelectionView: some View {
        VStack(spacing: 10.0) {
            RCSubTitle("시간")
            
            // 날짜 선택 버튼
            HStack {
                // 오늘 날짜 버튼
                SelectionButton(
                    DateType.today.description,
                    data: DateType.today,
                    selection: $dateSelection,
                    padding: 5.0
                ) {
                    checkButtonEnable()
                }
                // 내일 날짜 버튼
                SelectionButton(
                    DateType.tomorrow.description,
                    data: DateType.tomorrow,
                    selection: $dateSelection,
                    padding: 5.0
                ) {
                    checkButtonEnable()
                }
                // 모레 날짜 버튼
                SelectionButton(
                    DateType.dayAfterTomorrow.description,
                    data: DateType.dayAfterTomorrow,
                    selection: $dateSelection,
                    padding: 5.0
                ) {
                    checkButtonEnable()
                }
            }
            
            // 시간, 분 선택 버튼
            Button {
//                coordinator.present(sheet: .timeSetting)
            } label: {
                HStack {
                    Label(hourText + ":" + minuteText, systemImage: "alarm")
                    Spacer()
                }
                .foregroundStyle(.black)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: Configs.cornerRadius)
                        .stroke(Color.staticGray6, lineWidth: 1.0)
                }
            }
        }
    }
}

extension ThirdRoomCreateView {
    // 성별 선택 뷰
    var genderSelectionView: some View {
        // 참여가능 성별
        VStack(spacing: 10.0) {
            RCSubTitle("참여가능 성별", clarification: "선택")
            
            HStack(spacing: 10.0) {
                // 여성 버튼
                PointSelectionButton(
                    GenderType.female.rawValue,
                    data: GenderType.female,
                    selection: $genderSelection,
                    type: .middle
                )
                // 남성 버튼
                PointSelectionButton(
                    GenderType.male.rawValue,
                    data: GenderType.male,
                    selection: $genderSelection,
                    type: .middle
                )
            }
        }
    }
}

extension ThirdRoomCreateView {
    var staticGuageLimitView: some View {
        // 참여 가능 정전기 지수
        VStack(spacing: 20.0) {
            HStack {
                RCSubTitle(
                    "참여가능 정전기 지수",
                    clarification: "\(Int(staticGuageLimit))W이상",
                    type: .point
                )
                
                Toggle("", isOn: $hasScoreLimit)
                    .frame(width: 100.0)
                    .offset(x: -2.0)
            }
            
            if hasScoreLimit {
                Slider(value: $staticGuageLimit, in: 1 ... 100, step: 1.0)
                    .tint(Color.pointColor)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ThirdRoomCreateView(VM: RoomCreateViewModel())
//            .environmentObject(Coordinator())
            .environmentObject(UserService())
    }
}
