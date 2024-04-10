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
        case settings = "설정"
    }
    
    @State var selection: Category = .userManagement
    @State var isLogin: Bool = false
    
    var body: some View {
        
        if !isLogin {
            LoginView(isLogin: $isLogin)
        } else {
            NavigationSplitView {
                // Logo
                VStack {
                    // TODO: 스태틱 로고로 바꿔야 함
                    Image(.staticLogo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 300)
                    Text("관리자용 static")
                        .font(.title2)
                    // TODO: 악센트 컬러로 바꿔야 함
                        .foregroundStyle(.gray)
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
            PlaygroundManageMainView()
        // 문의 관리
        case .complaintManagement:
            ComplaintManagementView()
        // 공지사항 관리
        case .announcementManagement:
            AnnouncementManagementView()
        // 설정 뷰
        case .settings:
            SettingsView()
        }
    }
}

struct UserManagementView: View {
    var body: some View {
        Text("유저 관리")
    }
}

#Preview {
    ContentView()
}
