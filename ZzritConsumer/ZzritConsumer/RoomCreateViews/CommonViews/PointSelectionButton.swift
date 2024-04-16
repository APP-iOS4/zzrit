//
//  FilledSelectionButtonView.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/9/24.
//

import SwiftUI

import ZzritKit

struct PointSelectionButton<Data>: View where Data: Equatable {
    // MARK: - 저장 프로퍼티
    
    // 버튼 텍스트 변수
    private let title: String
    // 버튼이 눌렸을 때 변경되도록 하는 데이터
    private let data: Data
    // 선택에 따라 바인딩되는 텍스트 변수
    @Binding var selection: Data?
    // 패딩이 있을 경우 선택
    private var padding: CGFloat?
    // 버튼이 어디로 치우쳐져 있는지
    private var type: ButtonType
    // 추가적으로 버튼이 눌렸을 때 호출할 수 있는 함수
    private let onPressButton: () -> Void
    
    // MARK: - 연산 프로퍼티
    
    // 선택 여부
    private var isSelected: Bool {
        selection == data ? true : false
    }
    // 글자 색상
    private var fontColor: Color {
        isSelected ? Color.pointColor : Color.staticGray1
    }
    // 테두리 색상
    private var borderColor: Color {
        isSelected ? Color.pointColor : Color.staticGray5
    }
    // 배경 색상
    private var backGroundColor: Color {
        isSelected ? Color.lightPointColor : Color.staticGray6
    }
    
    // MARK: - init
    
    init(_ title: String, data: Data, selection: Binding<Data?>, padding: CGFloat? = nil, type: ButtonType = .side, onPressButton: @escaping () -> Void = { }) {
        self.title = title
        self.data = data
        self._selection = selection
        self.padding = padding
        self.type = type
        self.onPressButton = onPressButton
    }
    
    // MARK: - body
    
    var body: some View {
        Button {
            selection = data
            onPressButton()
        } label: {
            HStack {
                if type == .middle {
                    Spacer()
                }
                
                Text(title)
                    .padding(.horizontal)
                    .padding(.vertical, 10.0)
                    .foregroundStyle(fontColor)
                
                Spacer()
            }
            .overlay {
                RoundedRectangle(cornerRadius: Configs.cornerRadius)
                    .stroke(lineWidth: 1.0)
                    .foregroundStyle(borderColor)
            }
            .background(backGroundColor)
        }
    }
    
    enum ButtonType {
        case side
        case middle
    }
}

#Preview {
    PointSelectionButton("Hello", data: CategoryType.art, selection: .constant(CategoryType.art))
}
