//
//  ComplaintDetailView.swift
//  ZzritAdministrator
//
//  Created by 이우석 on 4/8/24.
//

// TODO: Complaint가 들어간 기존 뷰 파일 및 구조체 이름 모델에 맞추어 Contact로 변경, ContentView 목록의 신고도 문의로 변경 필요

import SwiftUI

import ZzritKit

struct ComplaintDetailView: View {
    @EnvironmentObject private var contactViewModel: ContactViewModel
    
    @Binding var contact: ContactModel?
    @Binding var isShowingModalView: Bool
    @State private var contactAnswerText: String = ""
    @State private var isContactAlert = false
    // @State private var isShowingGroupInfo = true
    @State private var selectInfoOrContent: InfoOrContent = .groupInfo
    
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
            ContactManageUserInfoView()
            HStack {
                VStack {
                    ContactManagerContentView(contact: $contact)
                    ContactManagerAnswerView(contactAnswerText: $contactAnswerText)
                    HStack {
                        Button {
                            isShowingModalView.toggle()
                        } label: {
                            StaticTextView(title: "돌아가기", width: 120, isActive: .constant(true))
                        }
                        
                        Spacer()
                        
                        Button {
                            if !contactAnswerText.isEmpty {
                                isContactAlert.toggle()
                                #if canImport(UIKit)
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                #endif
                            }
                        } label: {
                            StaticTextView(title: "답변 등록", width: 120, isActive: .constant(true))
                        }
                    }
                }
            }
        }
        .padding()
        .alert("답변을 등록하시겠습니까?", isPresented: $isContactAlert) {
            Button("취소하기", role: .cancel){
                isContactAlert.toggle()
            }
            Button("등록하기"){
                contactViewModel.replyContact(contact: contact ?? .init(category: .app, title: "", content: "", requestedDated: Date(), requestedUser: ""),
                                              replyContent: contactAnswerText)
                
                contactAnswerText = ""
                
                isContactAlert.toggle()
            }
        }
        .onTapGesture {
            #if canImport(UIKit)
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            #endif
        }
    }
}

enum InfoOrContent: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case groupInfo = "모임 정보"
    case groupChat = "채팅 내용"
}
