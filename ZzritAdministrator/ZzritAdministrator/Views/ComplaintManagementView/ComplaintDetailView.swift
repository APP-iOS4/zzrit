//
//  ComplaintDetailView.swift
//  ZzritAdministrator
//
//  Created by 이우석 on 4/8/24.
//

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

struct ContactManageUserInfoView: View {
    @Binding var contact: ContactModel?
    
    var body: some View {
        HStack {
            HStack(spacing: 30) {
                InfoLabelView(title: "이메일", contents: "\(contact?.requestedUser ?? "")")
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
            .padding(20)
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
    }
}

struct ContactManagerAnswerView: View {
    @Binding var contactAnswerText: String
    var body: some View {
        VStack() {
            HStack {
                Text("문의 답변")
                Spacer()
            }
            .padding(.top)
            TextField("문의에 대한 답변을 입력해 주세요.", text: $contactAnswerText)
                .padding(20)
                .frame(height: 150, alignment: .topLeading)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.staticGray3, lineWidth: 1.0)
                }
        }
    }
}

enum InfoOrContent: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case groupInfo = "모임 정보"
    case groupChat = "채팅 내용"
}


//#Preview {
//    ComplaintDetailView()
//}
