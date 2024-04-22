//
//  GeneralButton.swift
//  Zzrit
//
//  Created by 하윤호 on 3/19/24.
//

import SwiftUI

import ZzritKit

struct GeneralButton: View {
    // 비활성화 여부 변수
    var isDisabled: Bool
    // 버튼 텍스트 변수
    var title: String
    // 액션 변수
    var tapAction: () -> ()
    
    // MARK: - 초기값 설정
    
    // isDisabled는 기본값이 false, 사용자의 원하는 대로 true, false 지정
    init(_ title: String, isDisabled: Bool = false, tapAction: @escaping () -> ()) {
        self.isDisabled = isDisabled
        self.title = title
        self.tapAction = tapAction
    }
    
    // MARK: - body
    
    var body: some View {
        Button {
            tapAction()
        } label: {
            // 활성화 시 나오는 디자인
            if !isDisabled {
                Text("\(title)")
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.pointColor)
                    .clipShape(.rect(cornerRadius: 10))
            } else {
                // 비활성화시 디자인
                Text("\(title)")
                    .foregroundStyle(.black)
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.staticGray5)
                    .clipShape(.rect(cornerRadius: 10))
            }
        }
        .disabled(isDisabled)
    }
}

#Preview {
    GeneralButton("타이틀") {
        print("눌렸다")
    }
}
