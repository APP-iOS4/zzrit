//
//  SettingsView.swift
//  ZzritAdministrator
//
//  Created by Healthy on 4/8/24.
//

import SwiftUI
import ZzritKit

struct SettingsView: View {
    private let authService = AuthenticationService.shared
    
    @Binding var adminID: String
    @Binding var isLogin: Bool
    
    @State private var showLogoutAlert = false
    
    var body: some View {
        VStack {
            Text("로그인한 계정: \(adminID)")
            
            Spacer()
            
            Button {
                showLogoutAlert.toggle()
            } label: {
                StaticTextView(title: "로그아웃", isActive: .constant(true))
            }
            .frame(maxWidth: 300)
        }
        .padding(20)
        .alert("로그아웃", isPresented: $showLogoutAlert) {
            Button("취소", role: .cancel) {
                showLogoutAlert.toggle()
            }
            
            Button("로그아웃", role: .destructive){
                logout()
                showLogoutAlert.toggle()
            }
        } message: {
            Text("로그아웃 하시겠습니까?")
        }

    }
    
    private func logout() {
        do {
            try authService.logout()
            isLogin = false
        } catch {
            print("에러: \(error)")
        }
    }
}

#Preview {
    SettingsView(adminID: .constant("Example"), isLogin: .constant(true))
}
