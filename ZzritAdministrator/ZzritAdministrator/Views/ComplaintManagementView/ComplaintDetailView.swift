//
//  ComplaintDetailView.swift
//  ZzritAdministrator
//
//  Created by 이우석 on 4/8/24.
//

import SwiftUI

struct ComplaintDetailView: View {
    @Binding var qnaId: UUID?
    @Binding var isShowingModalView: Bool
    @State private var qnaAnswerText: String = ""
    @State private var isQnaAlert = false
    @State private var isShowingGroupInfo = false
    @State private var selectInfoOrContent: InfoOrContent = .groupInfo
    
    var body: some View {
        VStack {
            QnaManageUserInfoView()
            HStack {
                VStack {
                    QnaManagerContentView(isShowingGroupInfo: $isShowingGroupInfo, qnaId: $qnaId)
                    QnaManagerAnswerView(qnaAnswerText: $qnaAnswerText)
                    HStack {
                        Button {
                            isShowingModalView.toggle()
                        } label: {
                            StaticTextView(title: "목록 보기", width: 120, isActive: .constant(true))
                        }
                        
                        Spacer()
                        
                        Button {
                            if !qnaAnswerText.isEmpty {
                                isQnaAlert.toggle()
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
        .alert("답변을 등록하시겠습니까?", isPresented: $isQnaAlert) {
            Button("취소하기", role: .cancel){
                isQnaAlert.toggle()
            }
            Button("등록하기", role: .destructive){
                print("등록하기")
                isQnaAlert.toggle()
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

struct QnaManageUserInfoView: View {
    var body: some View {
        HStack {
            HStack(spacing: 30) {
                InfoLabelView(title: "이메일", contents: "hapanef@naver.com")
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

struct QnaManagerContentView: View {
    @Binding var isShowingGroupInfo: Bool
    @Binding var qnaId: UUID?
    
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
                    Text("\(tempQnaList.filter{ $0.id == qnaId }[0].qnaCategory.rawValue)")
                        .foregroundStyle(Color.pointColor)
                        .fontWeight(.bold)
                    HStack {
                        Text("\(tempQnaList.filter{ $0.id == qnaId }[0].qnaName)")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(tempQnaList.filter{ $0.id == qnaId }[0].qnaDate)")
                            .foregroundStyle(Color.staticGray3)
                    }
                    Divider()
                }
                Text("\(tempQnaList.filter{ $0.id == qnaId }[0].qnaContent)")
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

struct QnaManagerAnswerView: View {
    @Binding var qnaAnswerText: String
    var body: some View {
        VStack() {
            HStack {
                Text("문의 답변")
                Spacer()
            }
            .padding(.top)
            TextField("문의에 대한 답변을 입력해 주세요.", text: $qnaAnswerText)
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
