//
//  ProfileEditView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/9/24.
//

import SwiftUI

import ZzritKit

struct ProfileInfoView: View {
    private let authService = AuthenticationService.shared
    @EnvironmentObject private var userService: UserService
    
    //    @Binding var loginedInfo: UserModel?
    
    @State private var isEditViewDestination: Bool = false
    @State private var showModify: Bool = false
    @State private var uid: String = ""
    //    @State private var imageURL: URL?
    private var imageURL: URL? {
        return userService.loginedUser?.profileImage
    }
    private var name: String {
        return userService.loginedUser!.userName
    }
    
    var body: some View {
        HStack(spacing: 10) {
            AsyncImage(url: imageURL, scale: 1.0) { phase in
                phase
                    .resizable()
                    .frame(width: 50, height: 50)
            } placeholder: {
                Image("noProfile")
                    .resizable()
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame(width: 50, height: 50)
            }
            .aspectRatio(1.0, contentMode: .fill)
            .clipShape(.circle)
            .overlay {
                Circle()
                    .strokeBorder(Color.staticGray5, lineWidth: 1)
            }
            
            VStack {
                Text(name)
                    .font(.title3.bold())
            }
            
            Spacer()
            
            Button {
                showModify.toggle()
                // 애초에 현재 로그인한 상태라 유저정보가 없을 수 없다.
                uid = authService.currentUID!
            } label: {
                //Label("프로필 편집", image: "edit")
                Image(systemName: "pencil.line")
                    .padding()
                    .background(Color.staticGray6)
                    .clipShape(.rect(cornerRadius: 10))
            }
            .tint(.primary)
            .navigationDestination(isPresented: $showModify) {
                ModifyUserInfoView(registeredUID: $uid)
            }
            
        }
    }
}

//#Preview {
//    NavigationStack {
//        MoreInfoView()
//    }
//}
