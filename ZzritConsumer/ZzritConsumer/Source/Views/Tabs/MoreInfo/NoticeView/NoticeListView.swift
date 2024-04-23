//
//  NoticeListView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/9/24.
//

import SwiftUI

import ZzritKit

//공지사항 개수 - 임시
let noticeCount = 10

struct NoticeListView: View {
    
    private let noticeService = NoticeService()
    
    // TODO: 맨 아래로 스크롤 했을시 다음 공지사항 불러올수 있도록 페이징 처리
    
    // count는 받아오는 공지사항의 개수
    // 공지 개수가 많아 진다면 [버튼ID: Bool]() 형식의 딕셔너리로 처리하는게 어떤지 ..
    
    @State private var notices: [NoticeModel] = []
    @State private var isInitialFetch: Bool = true
    @State private var selectedNoticeID: String = ""
    
    @State private var showText = [Bool](repeating: false, count: noticeCount)
    
    var body: some View {
        NavigationStack{
            ScrollView {
                LazyVStack {
                    ForEach(notices) { notice in
                        Button {
                            if selectedNoticeID == notice.id! {
                                selectedNoticeID = ""
                            } else {
                                selectedNoticeID = notice.id!
                            }
                        } label: {
                            NoticeTitleView(title: notice.title, date: DateService.shared.formattedString(date: notice.date, format: "yyyy년 M월 d일"), isSelected: selectedNoticeID == notice.id!)
                        }
                        if selectedNoticeID == notice.id! {
                            // content: 공지 내용
                            NoticeContentView(content: notice.content)
                        } else {
                            // 미선택시 선으로만 보임
                            Divider()
                        }
                    }
                    
                    // 아래로 댕겼을때 자동으로 다음 공지사항을 불러오기 위한 꼼수...
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.clear)
                        .onAppear {
                            fetchNotice()
                        }
                }
            }
            .listStyle(.plain)
            .padding(.vertical, 1)
        }
        .navigationTitle("공지사항")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarRole(.editor)
    }
    private func fetchNotice() {
        Task {
            do {
                notices += try await noticeService.fetchNotice(isInitialFetch: isInitialFetch)
                isInitialFetch = false
            } catch {
                Configs.printDebugMessage("에러: \(error)")
            }
        }
    }
}

#Preview {
    NavigationStack{
        NoticeListView()
    }
}
