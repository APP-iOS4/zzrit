//
//  SecondRoomCreateView.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/9/24.
//

import SwiftUI

// TODO: 이름 및 모임 소개를 클릭하지 않았을 경우, 빨간색 에러 메세지로 한 글자라도 입력해달라고 한다.

struct SecondRoomCreateView: View {
    // 뷰모델
    let VM: RoomCreateViewModel
    
    // 이름 입력 받을 변수
    @State var title: String = ""
    // 모임 소개 내용을 입력 받을 변수
    @State var content: String = ""
    // 버튼 활성화 여부를 결정할 변수
    @State var isButtonEnabled: Bool = false
    // 다음 뷰 이동 변수
    @State var isShowingNextView: Bool = false
    
    var body: some View {
        NavigationStack {
            // 커스텀 네비게이션 바 - 두 번째 페이지
            RCNavigationBarView(page: .second)
                .padding()
            
            VStack {
                ScrollView(.vertical) {
                    // 이름을 입력 받는 뷰
                    VStack {
                        RoomCreateSubTitle("이름")
                        RCTitleTextField(text: $title) {
                            checkButtonDisabled()
                        }
                    }
                    .padding(.bottom)
                    
                    // 커버사진 입력 받는 뷰
                    VStack {
                        RoomCreateSubTitle("커버사진",clarification: "모임과 관련된 사진일수록 좋습니다." , type: .coverPhoto)
                        RoomCreateAddPictureView()
                            .frame(height: 180.0)
                    }
                    .padding(.vertical)
                    
                    // 모임 소개를 입력 받는 뷰
                    VStack {
                        RoomCreateSubTitle("모임 소개")
                        RCContentTextField(text: $content) {
                            checkButtonDisabled()
                        }
                    }
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
                }
            }
            .padding()
        }
    }
    
    // 화면에 있는 모든 텍스트 필드의 텍스트가 찼다면 버튼 활성화시키는 함수
    func checkButtonDisabled() {
        if !title.isEmpty && !content.isEmpty {
            isButtonEnabled = true
        } else {
            isButtonEnabled = false
        }
    }
}

#Preview {
    SecondRoomCreateView(VM: RoomCreateViewModel())
}
