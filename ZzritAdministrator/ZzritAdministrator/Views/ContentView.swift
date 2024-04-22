//
//  ContentView.swift
//  ZzritAdministrator
//
//  Created by Sanghyeon Park on 4/8/24.
//

import SwiftUI

struct ContentView: View {
    enum Category: String, CaseIterable, Identifiable {
        var id: UUID { UUID() }
        
        case playgroundMangement = "모임 관리"
        case userManagement = "유저 관리"
        case complaintManagement = "문의 관리"
        case announcementManagement = "공지사항 관리"
        case termsManagement = "이용약관 관리"
        case settings = "설정"
    }
    
    @State private var selection: Category = .userManagement
    @State private var isLogin: Bool = false
    @State private var adminName: String = ""
    @State private var adminID: String = ""
    
    var body: some View {
        
        if !isLogin {
            LoginView(isLogin: $isLogin, adminName: $adminName, adminID: $adminID)
        } else {
            NavigationSplitView {
                // Logo
                VStack {
                    Image(.staticLogo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 300)
                    Text("ZZ!RIT 관리")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(Color.staticGray2)
                    Text("\(adminName) 님")
                        .font(.subheadline)
                        .foregroundStyle(Color.staticGray)
                    Text("\(adminID)")
                        .foregroundStyle(Color.staticGray3)
                        .font(.caption)
                        .lineLimit(1)
                }
                
                // 하위 리스트
                List(Category.allCases) { category in
                    NavigationLink(destination: {
                        selectView(named: category)
                    }, label: {
                        Text("\(category.rawValue)")
                    })
                }
                .listStyle(.inset)
            } detail: {
                
            }
        }
    }

    @ViewBuilder
    func selectView(named category: Category) -> some View {
        switch category {
        // 유저 관리
        case .userManagement:
            // 레퍼런스 있음
            UserManageTableView()
        // 모임 관리
        case .playgroundMangement:
            // 레퍼런스 있음
            RoomManageView()
        // 문의 관리
        case .complaintManagement:
            ComplaintManagementView()
        // 공지사항 관리
        case .announcementManagement:
            NoticeManageView()
        // 이용약관 관리
        case .termsManagement:
            TermsView()
        // 설정 뷰
        case .settings:
            SettingsView(adminID: $adminID, isLogin: $isLogin)
        }
    }
}

#Preview {
    ContentView()
}
