//
//  UserInfoModalView.swift
//  ZzritAdministrator
//
//  Created by 이우석 on 4/8/24.
//

import SwiftUI

import ZzritKit

struct UserInfoModalView: View {
    @Binding var isUserModal: Bool
    @State private var isEditingIndex: Bool = false
    
    var user: UserModel
    
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
                    StaticTextView(title: "\(String(format: "%.1f", user.staticGuage))W", selectType: .gauge, width: 100, isActive: .constant(true))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
            }
            
            if isEditingIndex {
                StaticGaugeEditingSubview(user: user, indexAfterEdit: user.staticGuage, isUserModal: $isUserModal)
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

            BanList()
                .overlay {
                    RoundedRectangle(cornerRadius: Constants.commonRadius)
                        .stroke(Color.staticGray3, lineWidth: 1.0)
                }
            
            // Spacer(minLength: 100)
            
            HStack(spacing: 20) {
                Button {
                    isUserModal.toggle()
                }label: {
                    StaticTextView(title: "취소", isActive: .constant(false))
                }
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .frame(width: 100)
                
                BanReasonField(user: user, isUserModal: $isUserModal)
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
            Text("\(contents)")
        }
    }
}

struct BanList: View {
    var body: some View {
        ScrollView {
            ForEach(SomeoneBanList) { list in
                BanListCell(banDate: list.banDate, banPeriod: list.banPeriod, banReason: list.banReason, banManagerMemo: list.banManagerMemo)
            }
            .padding(20)
        }
    }
}

struct BanListCell: View {
    var banDate: String
    var banPeriod: Int
    var banReason: String
    var banManagerMemo: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("\(banDate)")
                    .fontWeight(.bold)
                HStack(spacing: 20) {
                    Text("\(banPeriod)일")
                        .fontWeight(.bold)
                        .foregroundStyle(Color.pointColor)
                    Text("\(banReason)")
                    Text("\(banManagerMemo)")
                        .foregroundStyle(Color.staticGray3)
                }
            }
            Spacer()
        }
        Divider()
    }
}

struct SomeoneBan: Identifiable {
    var id: UUID = UUID()
    
    let banDate: String
    let banPeriod: Int
    let banReason: String   //enum 예정
    let banManagerMemo: String
}

private var SomeoneBanList: [SomeoneBan] = [
    SomeoneBan(banDate: "2023-09-21", banPeriod: 3, banReason: "욕설 사용으로 인한 정지", banManagerMemo: "채팅 내용 중 욕설 사용 확인"),
    SomeoneBan(banDate: "2023-09-21", banPeriod: 3, banReason: "욕설 사용으로 인한 정지", banManagerMemo: "채팅 내용 중 욕설 사용 확인"),
    SomeoneBan(banDate: "2023-09-21", banPeriod: 3, banReason: "욕설 사용으로 인한 정지", banManagerMemo: "채팅 내용 중 욕설 사용 확인"),
    SomeoneBan(banDate: "2023-09-21", banPeriod: 3, banReason: "욕설 사용으로 인한 정지", banManagerMemo: "채팅 내용 중 욕설 사용 확인"),
    SomeoneBan(banDate: "2023-09-21", banPeriod: 3, banReason: "욕설 사용으로 인한 정지", banManagerMemo: "채팅 내용 중 욕설 사용 확인")
]

#Preview {
    UserInfoModalView(isUserModal: .constant(true), user: .init(userID: "example@example.com", userName: "EXAMPLE DATA", userImage: "xmark", gender: .male, birthYear: 1900, staticGuage: 0))
}
