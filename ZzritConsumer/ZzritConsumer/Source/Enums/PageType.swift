//
//  Page.swift
//  StaticTemp
//
//  Created by 이선준 on 4/13/24.
//

import SwiftUI

import ZzritKit
// MARK: - 가져가야 함

enum PageType: Hashable {
    case login(Login)
    case main
    case room(Room)
    case chatting(Chatting)
    case moreInfo(MoreInfo)
    case search(Search)
    case newRoom(NewRoom)
    
    var description: String {
        switch self {
        case .login(let detail):
            return detail.rawValue
        case .main:
            return "메인"
        case .room(let detail):
            return detail.rawValue
        case .chatting(let detail):
            return detail.rawValue
        case .moreInfo(let detail):
            return detail.rawValue
        case .search(let detail):
            return detail.rawValue
        case .newRoom(let detail):
            return detail.description
        }
    }
    
    /// 각 페이지에 따라 뷰 그리기
    @ViewBuilder
    func build() -> some View {
        switch self {
        // 로그인 그룹
        case .login(let login):
            switch login {
            // 로그인 페이지
            case .login:
                EmptyView()
            // 회원가입 아이디/비밀번호 페이지
            case .signUp:
                EmptyView()
            // 회원가입 유저 정보 입력 페이지
            case .setProfile:
                EmptyView()
            // 회원가입 완료 페이지
            case .complete:
                EmptyView()
            }
        // 메인 페이지
        case .main:
            MainView(offlineLocation: .constant(nil))
        // 모임 그룹
        case .room(let room):
            switch room {
            // 모임 디테일 페이지
            case .detail:
                RoomDetailView(offlineLocation: .constant(nil), room: RoomModel(title: "", category: .art, dateTime: Date(), content: "", coverImage: "https://picsum.photos/200", isOnline: false, status: .activation, leaderID: "", limitPeople: 8))
            // 모임 참여 시 안내사항 페이지
            case .notice:
                ParticipantNoticeView(room: RoomModel(title: "", category: .art, dateTime: Date(), content: "", coverImage: "https://picsum.photos/200", isOnline: false, status: .activation, leaderID: "", limitPeople: 8), confirmParticipation: .constant(false))
            // 채팅 페이지
            case .chatting:
                EmptyView()
                // ChattingView()
            }
        // 채팅 그룹
        case .chatting(let chatting):
            switch chatting {
            // 채팅 리스트 페이지
            case .list:
                EmptyView()
            // 채팅 페이지
            case .chatting:
//                ChattingView()
                EmptyView()
            }
        // 더보기 그룹
        case .moreInfo(let moreInfo):
            switch moreInfo {
            // 더보기 페이지
            case .userInfo:
                EmptyView()
            // 공지사항 페이지
            case .notic:
                EmptyView()
            }
        // 탑색 탭 그룹
        case .search(let search):
            switch search {
            // 탐색 페이지
            case .search:
                EmptyView()
            }
        // 모임 생성 그룹
        case .newRoom(let newRoom):
            switch newRoom {
            // 모임생성 1 페이지
            case .page1:
//                FirstRoomCreateView(VM: RoomCreateModel())
                EmptyView()
            // 모임생성 2 페이지
            case .page2:
                EmptyView()
            // 모임생성 3 페이지
            case .page3:
                EmptyView()
            }
        }
    }
}

enum Login: String, Hashable {
    case login = "로그인"
    case signUp = "회원가입"
    case setProfile = "회원정보 입력"
    case complete = "회원가입 완료"
}

enum Room: String, Hashable {
    case detail = "모임 상세페이지"
    case notice = "모임 안내화면"
    case chatting = "채팅"
}

enum Chatting: String, Hashable {
    case list = "채팅 목록"
    case chatting = "채팅"
}

enum MoreInfo: String, Hashable {
    case userInfo = "더보기"
    case notic = "공지사항"
}

enum Search: String, Hashable {
    case search = "탐색"
    // case result = "검색 결과"
}

enum NewRoom: Int, Identifiable, CaseIterable {
    var id: String {
        self.description
    }
    
    case page1 = 0
    case page2 = 1
    case page3 = 2
    
    var description: String {
        switch self {
        case .page1:
            "모임개설 페이지 1"
        case .page2:
            "모임개설 페이지 2"
        case .page3:
            "모임개설 페이지 3"
        }
    }
}
