//
//  SecondRoomCreateView.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/9/24.
//

import SwiftUI

// TODO: 이름 및 모임 소개를 클릭하지 않았을 경우, 빨간색 에러 메세지로 한 글자라도 입력해달라고 한다.

struct SecondRoomCreateView: View {
    
    // MARK: - 저장 프로퍼티
    
    // 코디네이터 객체
    @EnvironmentObject var coordinator: Coordinator
    // 뷰모델
    let VM: RoomCreateViewModel
    
    // 이름 입력 받을 변수
    @State private var title: String = ""
    // 사진 선택
    @State private var selectedImage: UIImage?
    // 이미지 저장s 
    @State private var image: Image?
    // 모임 소개 내용을 입력 받을 변수
    @State private var roomIntroduction: String = ""
    // 버튼 활성화 여부를 결정할 변수
    @State private var isButtonEnabled: Bool = false
    // 다음 화면으로 넘어가기
    @State private var isShowintNextView: Bool = false
    
    // MARK: - body
    
    var body: some View {
        NavigationStack {
            // 커스텀 네비게이션 바 - 두 번째 페이지
            RCNavigationBar(page: .page2) {
                ZStack {
                    // 스크롤 뷰
                    ScrollView(.vertical) {
                        // 이름을 입력 받는 뷰
                        VStack(spacing: 10.0) {
                            RCSubTitle("이름")
                            RCTitleTextField(text: $title) {
                                checkButtonDisabled()
                            }
                        }
                        .padding(.bottom, Configs.paddingValue)
                        
                        // 커버사진 입력 받는 뷰
                        VStack(spacing: 10.0) {
                            RCSubTitle("커버사진",
                                       clarification: "모임과 관련된 사진일수록 좋습니다.",
                                       type: .detail
                            )
                            RCAddPictureView(selectedImage: $selectedImage)
                                .frame(height: 180.0)
                        }
                        .padding(.bottom, Configs.paddingValue)
                        
                        // 모임 소개를 입력 받는 뷰
                        VStack(spacing: 10.0) {
                            RCSubTitle("모임 소개")
                            RCContentTextField(text: $roomIntroduction) {
                                checkButtonDisabled()
                            }
                        }
                    }
                    
                    VStack {
                        Spacer()
                        
                        GeneralButton(isDisabled: !isButtonEnabled, "다음") {
                            // VM에 새 모임 제목 저장
                            VM.saveTitle(title: title)
                            // VM에 새 모임의 소개글 저장
                            VM.saveIntroduction(roomIntroduction: roomIntroduction)
                            
                            // 다음 화면으로 이동
                            isShowintNextView.toggle()
                        }
                        .navigationDestination(isPresented: $isShowintNextView, destination: {
                            ThirdRoomCreateView(VM: VM)
                        })
                    }
<<<<<<< HEAD
                    .padding(.vertical)
                }
                .frame(minHeight: 500.0)
                
                Spacer()
                
                GeneralButton("다음", isDisabled: !isButtonEnabled) {
                    // VM에 새 모임 제목 저장
                    VM.saveNewRoomTitle(title: title)
                    // VM에 새 모임의 소개글 저장
                    VM.saveNewRoomContent(content: content)
                    
                    // 다음 화면으로 이동
                    isShowingNextView.toggle()
                }
                .navigationDestination(isPresented: $isShowingNextView) {
                    ThirdRoomCreateView()
=======
>>>>>>> c6d61d4 (feat: 코디네이터 기본 틀과 모임 생성 뷰 리펙토링 및 이미지 / 시간 선택 외의 기능 완)
                }
            }
        }
    }
    
    // 화면에 있는 모든 텍스트 필드의 텍스트가 찼다면 버튼 활성화시키는 함수
    func checkButtonDisabled() {
        if !title.isEmpty && !roomIntroduction.isEmpty {
            isButtonEnabled = true
        } else {
            isButtonEnabled = false
        }
    }
}

#Preview {
    NavigationStack {
        SecondRoomCreateView(VM: RoomCreateViewModel())
            .environmentObject(Coordinator())
    }
}
