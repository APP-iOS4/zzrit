//
//  ContactManageUserInfoView.swift
//  ZzritAdministrator
//
//  Created by 이우석 on 4/9/24.
//

import SwiftUI

import ZzritKit

struct ContactManageUserInfoView: View {
    @EnvironmentObject private var contactViewModel: ContactViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                InfoLabelView(title: "이메일", contents: "\(contactViewModel.userModel.userID)")
                
                HStack(spacing: 30) {
                    InfoLabelView(title: "출생년도", contents: "\(contactViewModel.userModel.birthYear)")
                    InfoLabelView(title: "성별", contents: "\(contactViewModel.userModel.gender.rawValue)")
                    Spacer()
                    HStack {
                        Text("계정 상태 : ")
                        Text("정상")
                            .fontWeight(.bold)
                            .foregroundStyle(Color.pointColor)
                    }
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.staticGray3, lineWidth: 1.0)
            }
            
            StaticTextView(title: "\(contactViewModel.userModel.staticGauge)W", width: 100, isActive: .constant(true))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
    }
}
