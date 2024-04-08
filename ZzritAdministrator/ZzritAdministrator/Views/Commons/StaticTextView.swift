//
//  StaticTextView.swift
//  ZzritAdministrator
//
//  Created by Healthy on 4/8/24.
//

import SwiftUI
import ZzritKit

struct StaticTextView: View {
    
    enum StaticTextType {
        case login
        case filter
        case text
    }
    
    var title: String
    var selectType: StaticTextType = .text
    var width: CGFloat = .infinity
    @Binding var isActive: Bool
    
    var backGroundColor: Color {
        switch selectType {
        case .login:
            return isActive ? Color.pointColor : Color.staticGray4
        case .filter:
            return isActive ? Color.pointColor : Color.staticGray4
         
        case .text:
            return Color.pointColor
        }
    }
    
    var font: Font {
        switch selectType {
        case .login, .filter:
            return .title2
        case .text:
            return .body
        }
    }
    
    var body: some View {
        Text(title)
            .font(font)
            .fontWeight(.bold)
            .padding()
            .frame(minWidth: 40.0, maxWidth: width)
            .foregroundStyle(.white)
            .background(backGroundColor)
            .clipShape(RoundedRectangle(cornerRadius: Constants.commonRadius))
    }
}

#Preview {
    StaticTextView(title: "로그인", selectType: .login, isActive: .constant(false))
}
