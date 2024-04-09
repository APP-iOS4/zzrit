//
//  WriteNoticeView.swift
//  ZzritModelTest
//
//  Created by Sanghyeon Park on 4/9/24.
//

import SwiftUI

import ZzritKit

struct WriteNoticeView: View {
    private let noticeService = NoticeService()
    
    @State private var title: String = ""
    @State private var content: String = ""
    var body: some View {
        VStack {
            TextField("공지사항 제목", text: $title)
            TextEditor(text: $content)
                .overlay {
                    if content == "" {
                        VStack {
                            HStack {
                                Text("내용을 입력하세요.")
                                
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                }
            
            Button("공지사항 등록") {
                writeNotice()
            }
        }
        .padding()
    }
    
    private func writeNotice() {
        if title == "" || content == "" {
            print("제목 또는 내용을 입력하세요.")
            return
        }
        
        Task {
            do {
                let tempNotice = NoticeModel(title: title, content: content, date: Date(), writerUID: "lZJDCklNWnbIBcARDFfwVL8oSCf1")
                try noticeService.writeNotice(tempNotice)
                print("공지사항 작성 완료")
            } catch {
                print("에러: \(error)")
            }
        }
    }
}

#Preview {
    WriteNoticeView()
}
