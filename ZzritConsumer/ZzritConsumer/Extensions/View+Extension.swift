//
//  View+Extension.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/10/24.
//

import SwiftUI

import ZzritKit

// 텍스트필드 뷰 클릭 시 비활성화
extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
    
    func roundedBorder(_ width: CGFloat = 1, color: Color = Color.staticGray5, radius: CGFloat = 10) -> some View {
        self
            .padding(.horizontal, 10)
            .padding(.vertical, 15)
            .background {
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .strokeBorder(color, lineWidth: width)
            }
        
    }
}
