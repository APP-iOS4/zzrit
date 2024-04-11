//
//  UserSectionHeader.swift
//  ZzritAdministrator
//
//  Created by 이우석 on 4/11/24.
//

import SwiftUI

struct UserSectionHeader: View {
    var body: some View {
        HStack {
            Text("유저 이메일")
                .minimumScaleFactor(0.5)
                .frame(minWidth: 200, alignment: .leading)
                .multilineTextAlignment(.leading)
            
            Spacer()
            Divider()
            
            Text("정전기 지수")
                .minimumScaleFactor(0.5)
                .frame(width: 100, alignment: .leading)
                .multilineTextAlignment(.leading)
            
            Divider()
            
            Text(verbatim: "출생 연도")
                .minimumScaleFactor(0.5)
                .frame(width: 120, alignment: .leading)
                .multilineTextAlignment(.leading)
            
            Divider()
            
            Text("성별")
                .minimumScaleFactor(0.5)
                .frame(width: 100, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
        .fontWeight(.bold)
        .foregroundStyle(Color.pointColor)
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
        .background {
            Rectangle()
                .foregroundStyle(Color.staticGray6)
        }
    }
}
