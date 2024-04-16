//
//  UserListView.swift
//  ZzritModelTest
//
//  Created by woong on 4/16/24.
//

import SwiftUI

import ZzritKit

struct UserListView: View {
    
    private let um = UserManageService()
    @State private var ul: [UserModel] = []
    
    var body: some View {
        List {
            Button {
                Task {
                    do {
                        try ul = await um.loadAllUsers()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            } label: {
                Text("유저 목록 불러오기")
            }
            ForEach(ul) { user in
                Text(user.userName)
            }
        }
    }
}

#Preview {
    UserListView()
}
