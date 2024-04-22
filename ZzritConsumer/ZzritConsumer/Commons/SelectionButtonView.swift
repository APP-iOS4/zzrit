//
//  SelectionButtonView.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/9/24.
//

import SwiftUI

struct SelectionButtonView<Data>: View where Data: Equatable {
    // 버튼 텍스트 변수
    let title: String
    // 버튼이 눌렸을 때 변경되도록 하는 데이터
    let data: Data
    // 선택에 따라 바인딩되는 텍스트 변수
    @Binding var selection: Data?
    // 패딩이 있을 경우 선택
    var padding: CGFloat? = nil
    // 추가적으로 버튼이 눌렸을 때 호출할 수 있는 함수
    var onPressButton: () -> Void = {}
    
    // 선택 여부
    var isSelected: Bool {
        selection == data ? true : false
    }
    // 글자 색상
    var fontColor: Color {
        isSelected ? Color.pointColor : Color.staticGray
    }
    // 테두리 색상
    var borderColor: Color {
        isSelected ? Color.pointColor : Color.staticGray5
    }
    // 배경 색상
    var backGroundColor: Color {
        isSelected ? Color.lightPointColor : Color.white
    }
    
    var body: some View {
        Button {
            selection = data
            onPressButton()
        } label: {
            Text("\(title)")
                .padding(.all, padding)
                .foregroundStyle(fontColor)
                .frame(maxWidth: .infinity)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(borderColor, lineWidth: 1.0)
                }
                .background(backGroundColor)
        }
    }
}

#Preview {
    SelectionButtonView(title: "hello", data: "hello", selection: .constant("Hello"))
}
