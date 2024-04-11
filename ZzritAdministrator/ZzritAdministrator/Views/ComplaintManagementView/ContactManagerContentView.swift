//
//  ContactManagerContentView.swift
//  ZzritAdministrator
//
//  Created by 이우석 on 4/9/24.
//

import SwiftUI

import ZzritKit

struct ContactManagerContentView: View {
    @Binding var isShowingGroupInfo: Bool
    @Binding var contact: ContactModel?
    let dateService = DateService.shared
    
    var targetUserString: String? {
        var users: String = ""
        
        guard let contact else {
            return nil
        }
        
        if let targetUser = contact.targetUser {
            for idx in targetUser.indices {
                users += "\(targetUser[idx])"
                
                if idx < targetUser.count - 1 {
                    users += ", "
                }
            }
        }
        
        return users
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .bottom) {
                Text("문의 내용")
                    .fontWeight(.bold)
                Spacer()
                // TODO: 모임내용 보여야할때 주석 풀기
                //                Button(action: {
                //                    isShowingGroupInfo.toggle()
                //                }, label: {
                //                    StaticTextView(title: "모임정보", width: 100, isActive: .constant(true))
                //                })
            }
            VStack(alignment: .leading, spacing: 30) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(contact?.category.rawValue ?? "")")
                        .foregroundStyle(Color.pointColor)
                        .fontWeight(.bold)
                    HStack {
                        Text("\(contact?.title ?? "")")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(dateService.dateString(date: contact?.requestedDated ?? Date()))")
                            .foregroundStyle(Color.staticGray3)
                    }
                    Divider()
                    
                    if contact?.targetRoom != nil && contact?.category == .room {
                        HStack {
                            Text("대상 모임: ")
                                .fontWeight(.bold)
                            Text("\(contact?.targetRoom ?? "")")
                        }
                    } else if contact?.targetUser != nil && contact?.category == .mamber {
                        HStack {
                            Text("대상 유저: ")
                                .fontWeight(.bold)
                            Text("\(targetUserString ?? "")")
                        }
                    }
                }
                Text("\(contact?.content ?? "")")
                Spacer(minLength: 10)
            }
            .padding(30)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.staticGray3, lineWidth: 1.0)
            }
        }
        .padding(.top, 10)
    }
}

