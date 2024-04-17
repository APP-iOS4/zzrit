//
//  AnnounceModalView.swift
//  ZzritAdministrator
//
//  Created by Healthy on 4/9/24.
//

import SwiftUI
import ZzritKit

struct NoticeDetailView: View {
    // 공지 뷰모델
    @EnvironmentObject private var noticeViewModel: NoticeViewModel
    @Environment(\.dismiss) private var dismiss
    
    // 알럿 종류를 구분하기 위한 enum
    @State private var alertCase: AlertCase? = nil
    // 알럿 표시
    @State private var showAlert: Bool = false
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var warning: Bool = false
    
    @State var notice: NoticeModel? = nil
    
    // 데이트 서비스
    private let dateService = DateService.shared

    // TODO: 뷰 뷴리는 로그인 뷰부터 짜고(급해서) 진행하겠습니다
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                TextField("공지 제목을 입력해주세요", text: $title)
                    .padding(10.0)
                    .padding(.leading)
                    .background {
                        RoundedRectangle(cornerRadius: Constants.commonRadius)
                            .strokeBorder(Color.staticGray3, lineWidth: 2)
                            .foregroundStyle(.white)
                            //.shadow(radius: 10)
                    }
                
                if let notice {
                    RoundedRectangle(cornerRadius: Constants.commonRadius)
                        .foregroundStyle(Color.staticGray2)
                        .frame(width: 120, height: 44)
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
                }
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("공지 내용")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    if warning {
                        Text("공지 내용을 입력하셔야 합니다*")
                            .foregroundStyle(Color.pointColor)
                            .fontWeight(.semibold)
                    }
                }
                Spacer()

                if let notice {
                    Text(dateService.formattedString(date: notice.date, format: "yyyy MM/dd HH:mm"))
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
            
            
            if let notice {
                HStack {
                    Text("작성자: \(notice.writerUID)")
                    
                    Spacer()
                    
                    Text("\(notice.id ?? "")")
                }
                .foregroundStyle(Color.staticGray3)
                
                HStack {
                    MyButton(named: "돌아가기") {
                        alertCase = .dismiss
                        showAlert = true
                    }
                    .frame(width: 120, height: 50)
                    
                    Spacer()
                    
                    MyButton(named: "공지수정") {
                        alertCase = .modify
                        showAlert = true
                    }
                    .frame(width: 120, height: 50)
                }
                .font(.title2)
                .fontWeight(.bold)
                .padding(.vertical)
            } else {
                HStack {
                    MyButton(named: "돌아가기") {
                        alertCase = .dismiss
                        showAlert = true
                    }
                    .frame(width: 120, height: 50)
                    
                    Spacer()
                    
                    MyButton(named: "공지 등록") {
                        alertCase = .register
                        showAlert = true
                    }
                    .frame(width: 120, height: 50)
                }
                .font(.title2)
                .fontWeight(.bold)
                .padding(.vertical)
            }
        }
        .padding(20)
        .onAppear {
            if let notice {
                title = notice.title
                content = notice.content
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
    
    /// 뒤로가기 얼럿
    private func getDismissAlert() -> Alert {
        return Alert(
            title: Text("목록으로 돌아가기"),
            message: Text("목록으로 돌아가시겠습니까?"),
            primaryButton: .destructive(Text("돌아가기"), action: {
                dismiss()
            }),
            secondaryButton: .cancel(Text("취소")))
    }
    
    /// 공지 등록 얼럿
    private func getRegisterAlert() -> Alert {
        return Alert(
            title: Text("공지 등록"),
            message: Text("공지를 등록하시겠습니까?"),
            primaryButton: .destructive(Text("등록"), action: {
                if checkIsBlank() {
                    return
                } else {
                    noticeViewModel.writeNotice(title: title, content: content)
                }
                alertCase = nil
                dismiss()
            }),
            secondaryButton: .cancel(Text("취소")))
    }
    
    /// 공지 삭제 얼럿
    private func getDeleteAlert() -> Alert {
        return Alert(
            title: Text("공지 삭제"),
            message: Text("공지를 정말 삭제하시겠습니까?"),
            primaryButton: .destructive(Text("삭제"), action: {
                guard let notice else { return }
                noticeViewModel.deleteNotice(noticeID: notice.id!)
                alertCase = nil
                dismiss()
            }),
            secondaryButton: .cancel(Text("취소")))
    }
    
    /// 공지 수정 얼럿
    private func getModifyAlert() -> Alert {
        return Alert(
            title: Text("공지 수정"),
            message: Text("공지를 정말 수정하시겠습니까?"),
            primaryButton: .destructive(Text("수정"), action: {
                // 이전 단계에서 옵셔널 바인딩을 했기 때문에 옵셔널 포스 언래핑
                noticeViewModel.updateNotice(noticeID: notice?.id, title: title, content: content)
                alertCase = nil
                dismiss()
            }),
            secondaryButton: .cancel(Text("취소")))
    }
    
    /// 빈 문자열인지 확인
    private func checkIsBlank() -> Bool {
        if title == "" || content == "" {
            warning = true
            return true
        } else {
            return false
        }
    }
}

#Preview {
    NoticeDetailView()
        .environmentObject(NoticeViewModel())
}

private enum AlertCase {
    case dismiss
    case register
    case delelte
    case modify
}
