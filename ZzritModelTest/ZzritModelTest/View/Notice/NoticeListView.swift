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
    
    var body: some View {
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
        }
        .onAppear {
            loadNotices()
        }
    }
    
    private func loadNotices() {
        Task {
            do {
                notices = try await noticeService.fetchNotice()
            } catch {
                print("에러: \(error)")
            }
        }
    }
}

#Preview {
    NoticeListView()
}
