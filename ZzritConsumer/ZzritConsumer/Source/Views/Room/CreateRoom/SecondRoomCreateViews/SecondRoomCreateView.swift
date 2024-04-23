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
    @State private var isShowingNextView: Bool = false
    
    // MARK: - body
    
    var body: some View {
        // 커스텀 네비게이션 바 - 두 번째 페이지
        RCNavigationBar(page: .page2, VM: VM) {
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
                    
                    GeneralButton("다음", isDisabled: !isButtonEnabled) {
                        // VM에 새 모임 제목 저장
                        VM.saveTitle(title: title)
                        // VM에 새 모임의 소개글 저장
                        VM.saveIntroduction(roomIntroduction: roomIntroduction)
                        // VM에 새 모임의 이미지를 저장
                        VM.saveUIImage(selectedUIImage: selectedImage)
                        
                        // 다음 화면으로 이동
                        isShowingNextView.toggle()
                    }
                    .navigationDestination(isPresented: $isShowingNextView) {
                        ThirdRoomCreateView(VM: VM)
                    }
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
    }
}
