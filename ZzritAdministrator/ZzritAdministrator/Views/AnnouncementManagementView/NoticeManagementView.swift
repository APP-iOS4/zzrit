//
//  announcementManagement.swift
//  ZzritAdministrator
//
//  Created by Healthy on 4/8/24.
//

import SwiftUI
import ZzritKit

struct NoticeManagementView: View {
    @State private var showNoticeModal: Bool = false
    @State private var selectedNotice: NoticeModel? = nil
    @State private var showtAlert: Bool = false
    
    @State private var notices: [NoticeModel] = []
    @State private var initialFetch: Bool = true
    
    // 데이트 포매터
    private var dateService = DateService.shared
    private let noticeService = NoticeService()
    
    // TODO: 뷰 뷴리는 로그인 뷰부터 짜고(급해서) 진행하겠습니다
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack(spacing: 20) {
                SearchField(placeHolder: "공지 제목을 입력하세요", action: {
                    print("검색")
                })
                
                RoundedRectangle(cornerRadius: Constants.commonRadius)
                    .foregroundStyle(Color.pointColor)
                    .frame(width: 100, height: 50)
                    .overlay(
                        Button {
                            selectedNotice = nil
                            showNoticeModal.toggle()
                        } label: {
                            Text("등록")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        }
                    )
            }
            
            HStack(spacing: 20) {
                ScrollView {
                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                        Section(header: NoticeHeader()) {
                            ForEach(notices) { notice in
                                Button {
                                    selectedNotice = notice
                                } label: {
                                    HStack {
                                        Text(notice.title)
                                        
                                        Spacer()
                                        Divider()
                                        
                                        Text(dateService.formattedString(date: notice.date, format: "yyyy/MM/dd HH:mm"))
                                            .frame(width: 150, alignment: .center)
                                    }
                                    .foregroundStyle(selectedNotice?.id == notice.id ? Color.pointColor : Color.black)
                                    
                                }
                                .id(notice.id)
                                .padding(10)
                            }
                            
                            Button {
                                
                            } label: {
                                Text("")
                            }
                            .onAppear {
                                print("FetchMore!!!!!!!")
                            }
                        }
                    }
                }
                .overlay {
                    RoundedRectangle(cornerRadius: Constants.commonRadius)
                        .stroke(Color.staticGray3, lineWidth: 1.0)
                }
            }
            
            MyButton(named: "선택한 공지 수정") {
                if selectedNotice != nil {
                    showNoticeModal.toggle()
                }
            }
            .frame(maxWidth: .infinity, alignment: .bottomTrailing)
        }
        .padding(20)
        .onAppear {
            loadNotices()
            initialFetch = false
        }
        .fullScreenCover(isPresented: $showNoticeModal, content: {
            NoticeModalView(notice: selectedNotice)
        })
    }
    
    private func loadNotices() {
        print("\(initialFetch)")
        
        Task {
            do {
                notices += try await noticeService.fetchNotice(isInitialFetch: initialFetch)
            } catch {
                print("에러: \(error)")
            }
        }
    }
}

#Preview {
    NoticeManagementView()
}
