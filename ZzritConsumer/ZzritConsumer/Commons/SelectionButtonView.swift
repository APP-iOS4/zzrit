//
//  SelectionButtonView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/8/24.
//

import SwiftUI

import ZzritKit

struct SelectionButtonView: View {
    // 선택 여부
    var isSelected: Bool
    // 버튼 텍스트 변수
    var title: String
    // 액션 변수
    var tapAction: () -> ()
    
    // MARK: - init
    
    // isDisabled는 기본값이 false, 사용자의 원하는 대로 true, false 지정
    init(isSelected: Bool = true, _ title: String, tapAction: @escaping () -> ()) {
        self.isSelected = isSelected
        self.title = title
        self.tapAction = tapAction
    }
    
    // MARK: - body
    
    var body: some View {
        Button {
            tapAction()
        } label: {
            Text("\(title)")
                .padding(10)
                .foregroundStyle(isSelected ? Color.pointColor : Color.staticGray)
                .frame(maxWidth: .infinity)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 1.0)
                        .foregroundStyle(isSelected ? Color.pointColor : Color.staticGray5)
                }
                .background(isSelected ? Color.lightPointColor : .white)
        }
    }
}

#Preview {
    SelectionButtonView("남자") {
        print("남자")
    }
}
