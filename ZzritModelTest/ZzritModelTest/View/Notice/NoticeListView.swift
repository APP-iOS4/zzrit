//
//  NoticeListView.swift
//  ZzritModelTest
//
//  Created by Sanghyeon Park on 4/9/24.
//

import SwiftUI

import ZzritKit

struct NoticeListView: View {
    private let noticeService = NoticeService()
    private let dateService = DateService.shared
    
    @State private var notices: [NoticeModel] = []
    @State private var selectedNoticeUID: String = ""
    @State private var initialFetch: Bool = true
    
    var body: some View {
        VStack {
            List(notices) { notice in
                VStack {
                    HStack {
                        VStack {
                            Text(notice.title)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(dateService.formattedString(date: notice.date))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        Spacer()
                        Image(systemName: selectedNoticeUID == notice.id! ? "chevron.up" : "chevron.down")
                    }
                    if selectedNoticeUID == notice.id! {
                        Text(notice.content)
                    }
                }
                .onTapGesture {
                    if selectedNoticeUID == notice.id! {
                        selectedNoticeUID = ""
                    } else {
                        selectedNoticeUID = notice.id!
                    }
                }
                Button("공지사항 삭제") {
                    deleteNotice(noticeID: notice.id!)
                }
            }
            .onAppear {
                loadNotices()
                initialFetch = false
            }
            Button("공지사항 더 불러오기") {
                loadNotices()
            }
        }
    }
    
    private func loadNotices() {
        Task {
            do {
                notices += try await noticeService.fetchNotice(isInitialFetch: initialFetch)
            } catch {
                print("에러: \(error)")
            }
        }
    }
    
    private func deleteNotice(noticeID: String) {
        Task {
            do {
                try await noticeService.deleteNotice(noticeID: noticeID)
                notices.remove(at: notices.firstIndex(where: {$0.id == noticeID})!)
            } catch {
                print("에러: \(error)")
            }
        }
    }
}

#Preview {
    NoticeListView()
}
