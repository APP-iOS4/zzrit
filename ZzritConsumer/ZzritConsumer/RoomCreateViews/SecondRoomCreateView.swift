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
            VStack(spacing: Configs.paddingValue) {
                // 두 번째 페이지 Indicator
                RoomCreateIndicator(page: .second)
                    .padding()
                
                // 이름을 입력 받는 뷰
                VStack {
                    RoomCreateSubTitle("이름")
                        .padding(.horizontal)
                    RoomCreateTextField(placeholder: "내용을 입력해주세요.")
                        .padding(.horizontal)
                }
                
                // 커버사진 입력 받는 뷰
                RoomCreateSubTitle("커버사진",clarification: "모임과 관련된 사진일수록 좋습니다." , type: .coverPhoto)
                    .padding(.horizontal)
                
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
