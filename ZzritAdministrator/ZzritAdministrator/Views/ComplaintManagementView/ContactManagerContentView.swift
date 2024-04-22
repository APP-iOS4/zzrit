//
//  ContactManagerContentView.swift
//  ZzritAdministrator
//
//  Created by 이우석 on 4/9/24.
//

import SwiftUI

import ZzritKit

struct ContactManagerContentView: View {
    @EnvironmentObject private var contactViewModel: ContactViewModel
    
    // @Binding var isShowingGroupInfo: Bool
    @Binding var contact: ContactModel?
    let dateService = DateService.shared
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
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
                    
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 30) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(contact?.category.rawValue ?? "")
                                    .foregroundStyle(Color.pointColor)
                                    .fontWeight(.bold)
                                HStack {
                                    Text(contact?.title ?? "")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    Spacer()
                                    Text(dateService.formattedString(date: contact?.requestedDate ?? Date(), format: "yyyy/MM/dd HH:mm:ss"))
                                        .foregroundStyle(Color.staticGray3)
                                }
                                Divider()
                                
                                if contact?.targetRoom != nil && contact?.category == .room {
                                    HStack {
                                        Text("대상 모임: ")
                                            .fontWeight(.bold)
                                        Text(contactViewModel.targetRoomModel?.title ?? "")
                                    }
                                    HStack {
                                        Text("카테고리: \(contactViewModel.targetRoomModel?.category.rawValue ?? "")")
                                        Text("인원: \(contactViewModel.targetRoomModel?.limitPeople ?? 0)명")
                                        
                                        Spacer()
                                        
                                        Button {
                                            
                                        } label: {
                                            HStack {
                                                Text("모임 상세정보")
                                                Image(systemName: "chevron.right")
                                            }
                                        }
                                    }
                                }
                            }
                            
                            Text(contact?.content ?? "")
                            
                            Spacer(minLength: 10)
                            
                            if !contactViewModel.repliedAdmins.isEmpty {
                                ForEach(contactViewModel.replies.indices, id: \.self) { index in
                                    Divider()
                                    HStack(alignment: .bottom) {
                                        Text("관리자 \(index >= contactViewModel.repliedAdmins.count ? "?" : contactViewModel.repliedAdmins[index].name)(\(index >= contactViewModel.repliedAdmins.count ? "?" : contactViewModel.repliedAdmins[index].email))의 답변")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                        
                                        Spacer()
                                        
                                        Text(dateService.formattedString(date: contactViewModel.replies[index].date, format: "yyyy/MM/dd HH:mm:ss"))
                                            .foregroundStyle(Color.staticGray3)
                                    }
                                    Text(contactViewModel.replies[index].content)
                                }
                            }
                            
                        }
                        .padding(30)
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.staticGray3, lineWidth: 1.0)
                    }
                }
                .padding(.top, 10)
                .frame(minWidth: geometry.size.width * 0.6)
                .onAppear {
                    contactViewModel.fetchReplies(contact: contact ?? .init(category: .app, title: "", content: "", requestedDated: Date(), requestedUser: ""))
                }
                
                if contact?.category == .room && contact?.targetUser != nil {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("대상 유저")
                            .fontWeight(.bold)
                        
                        if let targetUserModels = contactViewModel.targetUserModels {
                            ScrollView {
                                LazyVStack(alignment: .leading) {
                                    ForEach(targetUserModels) { target in
                                        Button {
                                            
                                        } label: {
                                            VStack(alignment: .leading, spacing: 10) {
                                                Text("이메일: \(target.userID)")
                                                Text("정전기 지수: \(String(format: "%.1f", target.staticGauge))W")
                                            }
                                            .foregroundStyle(Color.primary)
                                        }
                                    }
                                    .padding(5)
                                    Divider()
                                }
                                .padding(10)
                            }
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.staticGray3, lineWidth: 1.0)
                            }
                        }
                    }
                    .frame(maxWidth: geometry.size.width * 0.3)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                }
            }
        }
    }
}

