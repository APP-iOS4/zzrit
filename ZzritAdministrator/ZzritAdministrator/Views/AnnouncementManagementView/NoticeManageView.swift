//
//  announcementManagement.swift
//  ZzritAdministrator
//
//  Created by Healthy on 4/8/24.
//

import SwiftUI
import ZzritKit

struct NoticeManageView: View {
    // 공지 뷰모델
    @EnvironmentObject private var noticeViewModel: NoticeViewModel
    
    // 선택된 공지
    @State private var selectedNotice: NoticeModel? = nil
    @State private var showNoticeDetail: Bool = false
    @State private var showtAlert: Bool = false

    // 데이트 서비스
    private var dateService = DateService.shared
    
    // TODO: 뷰 뷴리는 로그인 뷰부터 짜고(급해서) 진행하겠습니다
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack(spacing: 20) {
                
                // TODO: 공지 검색 -> 보류
//                SearchField(placeHolder: "공지 제목을 입력하세요", action: {
//                    print("검색")
//                })
              
                Spacer()
                
                RoundedRectangle(cornerRadius: Constants.commonRadius)
                    .foregroundStyle(Color.pointColor)
                    .frame(width: 100, height: 50)
                    .overlay(
                        Button {
                            selectedNotice = nil
                            showNoticeDetail.toggle()
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
                            ForEach(noticeViewModel.notices) { notice in
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
                                    .foregroundStyle(selectedNotice?.id == notice.id ? Color.pointColor : Color.primary)
                                }
                                .padding(10)
                            }
                            
                            Button {
                                
                            } label: {
                                Text("")
                            }
//                            .onAppear {
//                                noticeViewModel.loadNotices()
//                                print("추가 공지 불러오기")
//                            }
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
                    showNoticeDetail.toggle()
                }
            }
            .frame(maxWidth: .infinity, alignment: .bottomTrailing)
        }
        .padding(20)
        .fullScreenCover(isPresented: $showNoticeDetail, content: {
            NoticeDetailView(notice: selectedNotice)
        })
    }
}

#Preview {
    NoticeManageView()
        .environmentObject(NoticeViewModel())
}
