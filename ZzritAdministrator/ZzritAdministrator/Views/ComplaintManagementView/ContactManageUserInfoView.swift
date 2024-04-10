//
//  ContactManageUserInfoView.swift
//  ZzritAdministrator
//
//  Created by 이우석 on 4/9/24.
//

import SwiftUI

import ZzritKit

struct ContactManageUserInfoView: View {
    @Binding var contact: ContactModel?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                InfoLabelView(title: "이메일", contents: "\(contact?.requestedUser ?? "")")
                
                HStack(spacing: 30) {
                    InfoLabelView(title: "출생년도", contents: "1992")
                    InfoLabelView(title: "성별", contents: "남자")
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
            
            StaticTextView(title: "72W", width: 100, isActive: .constant(true))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
    }
}
