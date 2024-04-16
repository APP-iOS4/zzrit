//
//  AnnounceViewModel.swift
//  ZzritAdministrator
//
//  Created by Healthy on 4/12/24.
//

import Foundation
import ZzritKit

@MainActor
final class NoticeViewModel: ObservableObject {
    @Published var notices: [NoticeModel] = []
    
    private var initialFetch: Bool = true
    private let noticeService = NoticeService()
    
    init() {
        loadNotices()
        initialFetch = false
    }
    
    /// 공지 서버에서 읽어오기
    func loadNotices() {
        Task {
            do {
                notices += try await noticeService.fetchNotice(isInitialFetch: initialFetch)
                // Testing
            } catch {
                print("에러: \(error)")
            }
        }
    }
    
    /// 공지 삭제 함수
    func deleteNotice(noticeID: String) {
        Task {
            do {
                try await noticeService.deleteNotice(noticeID: noticeID)
                // 앱(로컬) 데이터 수정
                if let index = notices.firstIndex(where: { $0.id == noticeID }) {
                    notices.remove(at: index)
                }
            } catch {
                print("에러: \(error)")
            }
        }
    }
    
    /// 공지 작성 함수
    func writeNotice(title: String, content: String) {
        Task {
            do {
                // TODO: writerUID 수정해야 함
                let tempNotice = NoticeModel(title: title, content: content, date: Date(), writerUID: "lZJDCklNWnbIBcARDFfwVL8oSCf1")
                try noticeService.writeNotice(tempNotice)
                print("공지사항 작성 완료")
                // 앱(로컬) 데이터 수정
                notices.append(tempNotice)
            } catch {
                print("에러: \(error)")
            }
        }
    }
    
    /// 공지 수정 함수
    func updateNotice(noticeID: NoticeModel.ID, title: String, content: String) {
        let date = Date()
        
        Task {
            do {
                // TODO: writerUID 수정해야 함
                let tempNotice = NoticeModel(id: noticeID, title: title, content: content, date: date, writerUID: "lZJDCklNWnbIBcARDFfwVL8oSCf1")
                try noticeService.modifyNotice(tempNotice)
                print("공지사항 수정 완료")
                
                // 앱(로컬) 데이터 수정
                if let index = notices.firstIndex(where: { $0.id == noticeID }) {
                    notices[index].title = title
                    notices[index].content = content
                    notices[index].date = date
                }
            } catch {
                print("에러: \(error)")
            }
        }
    }
}
