//
//  SelectionButton.swift
//  StaticTemp
//
//  Created by 이선준 on 4/14/24.
//

import SwiftUI

struct SelectionButton<Data>: View where Data: Equatable {
    
    // MARK: - 저장 프로퍼티
    
    // 버튼 텍스트 변수
    let title: String
    // 버튼이 눌렸을 때 변경되도록 하는 데이터
    let data: Data
    // 선택에 따라 바인딩되는 텍스트 변수
    @Binding var selection: Data?
    // 패딩이 있을 경우 선택
    var padding: CGFloat?
    // 추가적으로 버튼이 눌렸을 때 호출할 수 있는 함수
    let onPressButton: () -> Void
    
    // MARK: - 연산 프로퍼티
    
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
    
    // MARK: - init
    
    init(_ title: String, data: Data, selection: Binding<Data?>, padding: CGFloat? = nil, onPressButton: @escaping () -> Void = { }) {
        self.title = title
        self.data = data
        self._selection = selection
        self.padding = padding
        self.onPressButton = onPressButton
    }
    
    // MARK: - body
    
    var body: some View {
        Button {
            if selection == data {
                selection = nil
            } else {
                selection = data
            }
            onPressButton()
        } label: {
            HStack {
                Spacer()
                Text("\(title)")
                Spacer()
            }
            .padding(.all, padding)
            .foregroundStyle(fontColor)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(borderColor, lineWidth: 1.0)
            }
            .background(backGroundColor)
        }
    }
}

#Preview {
    SelectionButton("Hello", data: RoomProcessType.offline, selection: .constant(RoomProcessType.offline))
}
