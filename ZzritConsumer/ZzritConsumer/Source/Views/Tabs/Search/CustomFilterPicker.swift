//
//  CustomFilterPicker.swift
//  ZzritConsumer
//
//  Created by SunJoon Lee on 4/23/24.
//

import SwiftUI

struct CustomFilterPicker<Data>: View where Data: Equatable & RawRepresentable<String>, [Data]: Hashable {
    
    // MARK: 저장 프로퍼티
    
    // data에 해당하는 선택자
    @Binding var selection: Data?
    
    // 이름
    private let title: String
    // Equatable 프로토콜을 준수하는 콜렉션 데이터 (ForEach의 data와 동일)
    private let data: [Data]
    
    // MARK: - 연산 프로퍼티
    
    var pickerTitle: String {
        if let selection {
            return selection.rawValue
        } else {
            return title
        }
    }
    
    var fontColor: Color {
        if selection != nil {
            return Color.pointColor
        } else {
            return Color.primary
        }
    }
    
    var borderColor: Color {
        if selection != nil {
            return Color.pointColor
        } else {
            return Color.staticGray4
        }
    }
    
    var backgroundColor: Color {
        if selection != nil {
            return Color.lightPointColor
        } else {
            // FIXME: 다크모드 지원하려면 이 부분의 Color.white 수정해야함.
            
            return Color.white
        }
    }
    
    // MARK: - init
    
    init(_ title: String, data: [Data], selection: Binding<Data?>) {
        self.title = title
        self.data = data
        self._selection = selection
    }
    
    // MARK: - body
    
    var body: some View {
        Menu {
            ForEach(data, id: \.self) { category in
                Button {
                    selection = category
                } label: {
                    Text(category.rawValue)
                }
            }
        } label: {
            Label(pickerTitle, systemImage: "chevron.down")
                .foregroundStyle(fontColor)
                .padding(EdgeInsets(top: 5.0, leading: 10.0, bottom: 5.0, trailing: 15.0))
                .background {
                    RoundedRectangle(cornerRadius: Configs.cornerRadius)
                        .strokeBorder(borderColor, lineWidth: 1.0)
                        .background {
                            RoundedRectangle(cornerRadius: Configs.cornerRadius)
                                .fill(backgroundColor)
                        }
                }
        }
    }
}

#Preview {
    CustomFilterPicker("날짜", data: DateType.allCases, selection: .constant(nil))
}
