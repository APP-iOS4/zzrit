//
//  AnnounceModalView.swift
//  ZzritAdministrator
//
//  Created by Healthy on 4/9/24.
//

import SwiftUI
import ZzritKit

struct AnnounceModalView: View {
    @State var announcemnet: NoticeModel? = nil
    @State private var title: String = ""
    @State private var content: String = ""
    
    // 알럿 종류를 구분하기 위한 enum
    @State private var alertCase: AlertCase? = nil
    // 알럿 표시
    @State private var showAlert: Bool = false
   
    @Environment(\.dismiss) private var dismiss
    
    // 데이트 포매터
    var dateService = DateService.shared
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                TextField("공지 제목을 입력해주세요", text: $title)
                    .padding(10.0)
                    .padding(.leading)
                    .background {
                        RoundedRectangle(cornerRadius: Constants.commonRadius)
                            .foregroundStyle(.white)
                            .shadow(radius: 10)
                    }
                
                Button {                    
                    alertCase = .dismiss
                    showAlert = true
                } label: {
                    Image(systemName: "xmark.app.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 43)
                        .foregroundStyle(Color.staticGray3)
                }
            }
            
            HStack {
                Text("공지 내용")
                    .font(.title2)
             
                Spacer()

                if let announcemnet {
                    Text(dateService.formattedString(date: announcemnet.date, format: "yyyy MM/dd HH:mm"))
                        .foregroundStyle(Color.staticGray3)
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            
          TextField("공지 내용을 입력해주세요", text: $content, axis: .vertical)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding()
            .overlay {
                RoundedRectangle(cornerRadius: Constants.commonRadius)
                    .stroke(Color.staticGray3, lineWidth: 1.0)
            }
            
            
            if let announcemnet {
                HStack {
                    Text("작성자: \(announcemnet.writerUID)")
                    
                    Spacer()
                    
                    Text("\(announcemnet.id ?? "")")
                }
                .foregroundStyle(Color.staticGray3)
                
                HStack {
                    RoundedRectangle(cornerRadius: Constants.commonRadius)
                        .foregroundStyle(Color.staticGray2)
                        .frame(width: 160, height: 50)
                        .overlay(
                            Button {
                                alertCase = .delelte
                                showAlert = true
                            } label: {
                                Text("공지 삭제")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                            }
                        )
                    
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: Constants.commonRadius)
                        .foregroundStyle(Color.pointColor)
                        .frame(width: 280, height: 50)
                        .overlay(
                            Button {
                                alertCase = .modify
                                showAlert = true
                            } label: {
                                Text("공지 수정")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                            }
                        )
                }
                .padding(.vertical)
            } else {
                MyButton(named: "공지 등록") {
                    alertCase = .register
                    showAlert = true
                }
                .padding(.vertical)
            }
        }
        .padding(20)
        .onAppear {
            if let announcemnet {
                title = announcemnet.title
                content = announcemnet.content
            }
        }
        .alert(isPresented: $showAlert, content: {
            switch alertCase {
            case .dismiss:
                getDismissAlert()
            case .register:
                getRegisterAlert()
            case .delelte:
                getDeleteAlert()
            case .modify:
                getModifyAlert()
            case nil:
                getDismissAlert()
            }
        })
    }
    
    // TODO: 로직 추가해야 함
    /// 뒤로가기 얼럿
    func getDismissAlert() -> Alert {
        return Alert(
            title: Text("목록으로 돌아가기"),
            message: Text("목록으로 돌아가시겠습니까?"),
            primaryButton: .destructive(Text("돌아가기"), action: {
                dismiss()
            }),
            secondaryButton: .cancel(Text("취소")))
    }
    
    /// 공지 등록 얼럿
    func getRegisterAlert() -> Alert {
        return Alert(
            title: Text("공지 등록"),
            message: Text("공지를 등록하시겠습니까?"),
            primaryButton: .destructive(Text("등록"), action: {
               // TODO: 공지 등록 로직
                alertCase = nil
                dismiss()
            }),
            secondaryButton: .cancel(Text("취소")))
    }
    
    /// 공지 삭제 얼럿
    func getDeleteAlert() -> Alert {
        return Alert(
            title: Text("공지 삭제"),
            message: Text("공지를 정말 삭제하시겠습니까?"),
            primaryButton: .destructive(Text("삭제"), action: {
               // TODO: 공지 삭제 로직
                alertCase = nil
                dismiss()
            }),
            secondaryButton: .cancel(Text("취소")))
    }
    
    /// 공지 수정 얼럿
    func getModifyAlert() -> Alert {
        return Alert(
            title: Text("공지 수정"),
            message: Text("공지를 정말 수정하시겠습니까?"),
            primaryButton: .destructive(Text("수정"), action: {
               // TODO: 공지 수정 로직
                alertCase = nil
                dismiss()
            }),
            secondaryButton: .cancel(Text("취소")))
    }
}

#Preview {
    AnnounceModalView()
}

private enum AlertCase {
    case dismiss
    case register
    case delelte
    case modify
}
