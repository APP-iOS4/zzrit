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
    @Binding var contact: ContactModel?
    @Binding var isShowingModalView: Bool
    @State private var contactAnswerText: String = ""
    @State private var isContactAlert = false
    @State private var isShowingGroupInfo = false
    @State private var selectInfoOrContent: InfoOrContent = .groupInfo
    
    var body: some View {
        VStack {
            ContactManageUserInfoView(contact: $contact)
            HStack {
                VStack {
                    ContactManagerContentView(isShowingGroupInfo: $isShowingGroupInfo, contact: $contact)
                    ContactManagerAnswerView(contactAnswerText: $contactAnswerText)
                    HStack {
                        Button {
                            isShowingModalView.toggle()
                        } label: {
                            StaticTextView(title: "목록 보기", width: 120, isActive: .constant(true))
                        }
                        
                        Spacer()
                        
                        Button {
                            if !contactAnswerText.isEmpty {
                                isContactAlert.toggle()
                            }
                        } label: {
                            StaticTextView(title: "답변 등록", width: 120, isActive: .constant(true))
                        }
                    }
                }
                if isShowingGroupInfo{
                    VStack {
                        Picker("InfoOrContent", selection: $selectInfoOrContent){
                            ForEach(InfoOrContent.allCases) { chooseOne in
                                Text(chooseOne.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                        .onTapGesture {
                            switch selectInfoOrContent {
                            case .groupInfo:
                                selectInfoOrContent = .groupChat
                            case .groupChat:
                                selectInfoOrContent = .groupInfo
                            }
                        }
                        switch selectInfoOrContent {
                        case .groupInfo:
                            VStack {
                                // TODO: NewPlaygroundModalView
                                Spacer()
                            }
                            .padding(20)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.staticGray3, lineWidth: 1.0)
                            }
                        case .groupChat:
                            VStack {
                                // TODO: ChattingRoomView 참고해서
                                Spacer()
                            }
                            .padding(20)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.staticGray3, lineWidth: 1.0)
                            }
                        }
                    }
                    .padding()
                    .frame(width: 400)
                }
            }
        }
        .padding()
        .alert("답변을 등록하시겠습니까?", isPresented: $isContactAlert) {
            Button("취소하기", role: .cancel){
                isContactAlert.toggle()
            }
            Button("등록하기"){
                print("등록하기")
                isContactAlert.toggle()
            }
        }
        //         message: {
        //        }
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
