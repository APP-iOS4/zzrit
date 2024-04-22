//
//  UserInfoModalView.swift
//  ZzritAdministrator
//
//  Created by 이우석 on 4/8/24.
//

import SwiftUI

import ZzritKit

struct UserInfoModalView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    
    @Binding var isUserModal: Bool
    @State private var isEditingIndex: Bool = false
    
    @State var user: UserModel
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                HStack(spacing: 30){
                    InfoLabelView(title: "이메일", contents: "\(user.userID)")
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
                    Spacer()
                    
                    InfoLabelView(title: "출생년도", contents: "\(user.birthYear)")
                    InfoLabelView(title: "성별", contents: "\(user.gender.rawValue)")
                }
                .padding(20)
                .overlay {
                    RoundedRectangle(cornerRadius: Constants.commonRadius)
                        .stroke(Color.staticGray3, lineWidth: 1.0)
                }
                
                Button {
                    isEditingIndex.toggle()
                } label: {
                    StaticTextView(title: "\(String(format: "%.1f", user.staticGauge))W", selectType: .gauge, width: 100, isActive: .constant(true))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
            }
            
            if isEditingIndex {
                StaticGaugeEditingSubview(user: $user, indexAfterEdit: user.staticGauge, isUserModal: $isUserModal)
            }
            
            HStack {
                Text("제재 이력")
                    .fontWeight(.bold)
                Spacer()
                HStack {
                    Text("계정 상태 : ")
                    Text("정상")
                        .fontWeight(.bold)
                        .foregroundStyle(Color.pointColor)
                }
            }

            BanList(userViewModel: userViewModel, user: $user)
                .overlay {
                    RoundedRectangle(cornerRadius: Constants.commonRadius)
                        .stroke(Color.staticGray3, lineWidth: 1.0)
                }
            
            // Spacer(minLength: 100)
            
            HStack(spacing: 20) {
                Button {
                    isUserModal.toggle()
                }label: {
                    StaticTextView(title: "돌아가기", width: 120, isActive: .constant(false))
                }
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                
                BanReasonField(user: $user, isUserModal: $isUserModal)
            }
        }
        .tint(.pointColor)
        .padding(20)
        .onTapGesture {
            #if canImport(UIKit)
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            #endif
        }
    }
}

struct InfoLabelView: View {
    var title: String
    var contents: String
    var body: some View {
        HStack {
            Text("\(title) : ")
                .fontWeight(.bold)
                .foregroundStyle(Color.pointColor)
            Text(contents)
        }
    }
}

#Preview {
    UserInfoModalView(isUserModal: .constant(true), user: .init(userID: "example@example.com", userName: "EXAMPLE DATA", userImage: "xmark", gender: .male, birthYear: 1900, staticGauge: 0, agreeServiceDate: Date(), agreePrivacyDate: Date(), agreeLocationDate: Date()))
        .environmentObject(UserViewModel())
}
