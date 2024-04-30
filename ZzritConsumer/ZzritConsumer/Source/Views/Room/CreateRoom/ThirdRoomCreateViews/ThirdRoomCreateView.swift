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
    @EnvironmentObject var purchaseViewModel: PurchaseViewModel
    @EnvironmentObject var loadRoomViewModel: LoadRoomViewModel
    
    // 입장 메시지 입력을 위한 채팅
    @StateObject private var chattingService = ChattingService(roomID: " ")
    
    let VM: RoomCreateViewModel = RoomCreateViewModel.shared
    
    // FIXME: 모임 위치 변수 -
    // 오프라인/온라인 선택 변수
    @State private var processSelection: RoomProcessType?
    // 플랫폼 선택 변수
    @State private var platformSelection: PlatformType?
    // 오프라인 장소 변수
    @State private var offlineLocation: OfflineLocationModel?
    // 날짜 선택 변수
    @State private var dateSelection: DateType?
    // 시간 선택 변수
    @State private var timeSelection: Date?
    // 참여자 수 제한 변수
    @State private var limitPeople: Int = 2
    // 최대 참여자 수 제한 변수
    @State private var limitMaximumPeople: Int = 0
    // 성별 제한 선택 변수
    @State private var genderSelection: GenderType?
    // 정전기지수 제한이 있는지 없는지 선택하는 변수
    @State private var hasScoreLimit: Bool = false
    // 정전기지수 제한 값 - slider는 int 없음
    @State private var staticGuageLimit: Double = 20.0
    
    // 버튼 활성화 여부를 결정할 변수
    @State private var isButtonEnabled: Bool = false
    // 지도 시트 활성화 여부
    @State private var isShowingMapSheet: Bool = false
    // 시간 시트 활성화 여부
    @State private var isShowingTimeSheet: Bool = false
    
    @State private var isCreateNewRoom: Bool = false
    
    @State private var isShowingPurchaseView: Bool = false
    
    // MARK: - body
    
    var body: some View {
        RCNavigationBar(page: .page3) {
            ZStack {
                ScrollView {
                    // 진행방식을 입력 받는 뷰
                    RCProcedurePicker(processSelection: $processSelection, platformSelection: $platformSelection, offlineLocation: $offlineLocation) {
                        // 피커 버튼 눌렀을 때 사용할 함수
                        if purchaseViewModel.isPurchased {
                            limitMaximumPeople = 99
                        } else {
                            switch processSelection {
                            case .offline:
                                limitMaximumPeople = 3
                            case .online:
                                limitMaximumPeople = 5
                            case nil:
                                limitMaximumPeople = 3
                            }
                        }
                        checkButtonEnable()
                    }
                    
                    // 시간을 입력 받는 뷰
                    timeSelectionView
                        .padding(.bottom, Configs.paddingValue)
                    
                    if let _ = processSelection {
                        // 정원 선택 화면
                        RCParticipantsSection(participantsLimit: $limitPeople, limitMaxmium: $limitMaximumPeople)
                            .padding(.bottom, Configs.paddingValue)
                    }
                    
                    if !purchaseViewModel.isPurchased {
                        Text("찌릿 Pro를 구독하시면, 더 많은 사람들을 모집할 수 있어요!")
                            .foregroundStyle(Color.pointColor)
                            .font(.callout)
                            .offset(y: -10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    
                    VStack {
                        // 성별 선택 화면
                        genderSelectionView
                            .padding(.bottom, Configs.paddingValue)
                        
                        staticGuageLimitView
                    }
                    .overlay {
                        if !purchaseViewModel.isPurchased {
                            ZStack {
                                Color.clear
                                    .background(.regularMaterial)
                                
                                VStack {
                                    Text("찌릿 Pro를 구독하고 참여조건을 설정하세요!")
                                    Button {
                                        isShowingPurchaseView.toggle()
                                    } label: {
                                        Text("구독하기")
                                            .foregroundStyle(.white)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .background {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .foregroundStyle(Color.pointColor)
                                            }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            // 다음으로 넘어가기 버튼
            GeneralButton("완료", isDisabled: !isButtonEnabled) {
                if !isCreateNewRoom {
                    Task {
                        // 로그인 회원만 해당 뷰에 들어와 있으므로 강제 언래핑
                        if !purchaseViewModel.isPurchased {
                            let uid = AuthenticationService.shared.currentUID!
                            
                            let createdRoomCount = await userService.createdRoomsCount(uid)
                            
                            if createdRoomCount >= Configs.freeDailyCreateRoomCount {
                                isShowingPurchaseView.toggle()
                                return
                            }
                        }
                        
                        isCreateNewRoom.toggle()
                        VM.saveRoomProcess(
                            processSelection: processSelection,
                            placeLatitude: offlineLocation?.latitude,
                            placeLongitude: offlineLocation?.longitude,
                            placeName: offlineLocation?.placeName,
                            platform: platformSelection
                        )
                        
                        VM.saveDateTime(
                            dateSelection: dateSelection,
                            timeSelection: timeSelection ?? .now
                        )
                        
                        VM.saveGenderLimitation(genderLimitation: genderSelection)
                        
                        VM.saveScoreLimitation(
                            hasScoreLimit: hasScoreLimit,
                            scoreLimitation: staticGuageLimit
                        )
                        
                        VM.saveLimitPeople(limitPeople: limitPeople)
                        
                        let userInfo = userService.loginedUser
                        let newRoom = await VM.createRoom(userModel: userInfo)
                        let roomID = newRoom?.id
                        let userID = userInfo?.id ?? " "
                        if let roomID = roomID {
                            if let newRoom {
                                loadRoomViewModel.addNewRoomToData(newRoom: newRoom)
                            }
                            VM.topDismiss?.callAsFunction()
                        } else {
                            isCreateNewRoom = false
                        }
                        
                    }
                }
            }
        }
        .onTapGesture {
            endTextEditing()
        }
        .sheet(isPresented: $isShowingPurchaseView) {
            PurchaseView()
        }
        .customOnChange(of: offlineLocation, handler: { _ in
            checkButtonEnable()
        })
        .loading(isCreateNewRoom)
        .onAppear {
            timeSelection = tenMinutes()
        }
    }
    
    func checkButtonEnable() {
        guard let _ = dateSelection else {
            isButtonEnabled = false
            return
        }
        
        switch processSelection {
        case .online:
            if let _ = platformSelection {
                isButtonEnabled = true
            } else {
                isButtonEnabled = false
            }
        case .offline:
            if let _ = offlineLocation {
                isButtonEnabled = true
            } else {
                isButtonEnabled = false
            }
        case nil:
            return
        }
    }
    
    /// 10분 단위로 반올림
    func tenMinutes() -> Date {
        print("=== tenMinutes")
        
        let currentDate = Date()
        
        // 현재 달력을 가져옴
        let calendar = Calendar.current
        // 현재 분을 가져옴
        let minutes = calendar.component(.minute, from: currentDate)
        // 분 단위를 반올림할 값
        let roundingIncrement = 10
        // 반올림된 분 값 계산
        let roundedMinutes = Int(round(Double(minutes) / Double(roundingIncrement)) * Double(roundingIncrement))
        
        // 반올림된 분 값이 현재 분 값과 다른 경우, 시간을 조정하여 반환
        var roundedDate = currentDate
        
        if roundedMinutes != minutes {
            // 반올림된 분 값을 현재 시간에 반올림된 분 값과의 차이만큼 더하여 조정
            roundedDate = calendar.date(byAdding: .minute, value: roundedMinutes - minutes, to: roundedDate) ?? currentDate
        }
        
        print("=== \(roundedDate)")
        return roundedDate
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
                isShowingTimeSheet.toggle()
            } label: {
                HStack {
                    Label(timeSelection?.toStringTimeLine() ?? "", systemImage: "alarm")
                    Spacer()
                }
                .foregroundStyle(.black)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: Configs.cornerRadius)
                        .strokeBorder(Color.staticGray6, lineWidth: 1.0)
                }
            }
            .sheet(isPresented: $isShowingTimeSheet) {
                RCTimeSettingView(isShowingTimeSheet: $isShowingTimeSheet, timeSelection: $timeSelection)
                    .presentationDetents([
                        .fraction(0.4), // 임의 비율
                    ])
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
                    "정전기지수 제한",
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
        ThirdRoomCreateView()
        //            .environmentObject(Coordinator())
            .environmentObject(UserService())
            .environmentObject(PurchaseViewModel())
            .environmentObject(LoadRoomViewModel())
    }
}
