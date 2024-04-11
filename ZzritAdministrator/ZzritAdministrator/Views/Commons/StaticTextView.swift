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
        case gauge
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
         
        case .text, .gauge:
            return Color.pointColor
        }
    }
    
    var font: Font {
        switch selectType {
        case .login, .filter, .gauge:
            return .title2
        case .text:
            return .title3
        }
    }
    
    var padding: CGFloat {
        switch selectType {
        case .login, .text:
            15
        case .filter:
            12.5
        case .gauge:
            18
        }
    }
    
    var body: some View {
        Text(title)
            .font(font)
            .fontWeight(.bold)
            .padding(padding)
            .frame(minWidth: 40.0, maxWidth: width)
            .foregroundStyle(.white)
            .background(backGroundColor)
            .clipShape(RoundedRectangle(cornerRadius: Constants.commonRadius))
    }
}

#Preview {
    StaticTextView(title: "로그인", selectType: .login, isActive: .constant(false))
}
