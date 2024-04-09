//
//  SecondRoomCreateView.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/9/24.
//

import SwiftUI

struct SecondRoomCreateView: View {
    @Environment(\.dismiss) private var dismiss
    @State var isOnNextButton: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                // 두 번째 페이지 Indicator
                RoomCreateIndicator(page: .second)
                    .padding()
                
                // 이름을 입력 받는 뷰
                VStack {
                    RoomCreateSubTitle("이름")
                    RoomCreateTextField(placeholder: "내용을 입력해주세요.")
                }
                .padding()
                
                // 커버사진 입력 받는 뷰
                VStack {
                    RoomCreateSubTitle("커버사진",clarification: "모임과 관련된 사진일수록 좋습니다." , type: .coverPhoto)
                    RoomCreateAddPictureView()
                        .frame(height: 180.0)
                }
                .padding()
                
                VStack {
                    RoomCreateSubTitle("모임 소개")
                    RoomCreateTextField(placeholder: "모임에 대해 소개해주세요.", type: .roomIntroduce)
                }
                .padding()
                
                GeneralButton(isDisabled: !isOnNextButton, "다음",tapAction: {
                    
                })
                .padding()
            }
            .navigationTitle("모임개설")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading, content: {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundStyle(.black)
                    }
                })
            }
        }
    }
}

#Preview {
    SecondRoomCreateView()
}
