//
//  AdminManageView.swift
//  ZzritModelTest
//
//  Created by Sanghyeon Park on 4/11/24.
//

import SwiftUI

struct AdminManageView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("관리자 계정 생성") {
                    CreateAdminAccountView()
                }
                
                NavigationLink("관리자 로그인") {
                    AdminLoginView()
                }
                
                NavigationLink("이용약관 등록") {
                    AddTermView()
                }
                NavigationLink("UserManagingView") {
                    UserManagingView()
                }
            }
        }
    }
}

#Preview {
    AdminManageView()
}
