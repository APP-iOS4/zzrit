//
//  FilledSelectionButtonView.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/9/24.
//

import SwiftUI

struct CategoryCellView: View {
    // 버튼이 눌렸을 때 변경되도록 하는 데이터
    let data: FilterCategory
    // 선택에 따라 바인딩되는 텍스트 변수
    @Binding var selection: FilterCategory?
    
    // 버튼이 눌렸을 때 호출되는 클로저
    var onPressButton: () -> Void
    
    // 선택 여부
    var isSelected: Bool {
        selection == data ? true : false
    }
    // 글자 색상
    var fontColor: Color {
        isSelected ? Color.pointColor : Color.staticGray1
    }
    // 테두리 색상
    var borderColor: Color {
        isSelected ? Color.pointColor : Color.staticGray5
    }
    // 배경 색상
    var backGroundColor: Color {
        isSelected ? Color.lightPointColor : Color.staticGray6
    }
    
    var body: some View {
        Button {
            selection = data
            onPressButton()
        } label: {
            HStack {
                Text("#\(data.rawValue)")
                    .padding(.horizontal)
                    .padding(.vertical, 10.0)
                    .foregroundStyle(fontColor)
                Spacer()
            }
            .overlay {
                RoundedRectangle(cornerRadius: 8.0)
                    .strokeBorder(Color.staticGray4, lineWidth: 1.0)
            }
            .background(backGroundColor)
        }
    }
}

#Preview {
    CategoryCellView(data: .all, selection: .constant(.all)) {
        
    }
}
