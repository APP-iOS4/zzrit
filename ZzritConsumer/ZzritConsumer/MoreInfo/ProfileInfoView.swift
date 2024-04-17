//
//  ProfileEditView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/9/24.
//

import SwiftUI

import ZzritKit

struct ProfileInfoView: View {
    let loginedInfo: UserModel
    
    @State private var isEditViewDestination: Bool = false
    
    
    var body: some View {
        HStack(spacing: 10) {
            AsyncImage(url: loginedInfo.profileImage, scale: 1.0) { phase in
                phase
                    .resizable()
                    .frame(width: 50, height: 50)
            } placeholder: {
                Image("DummyImage")
                    .frame(width: 50, height: 50)
            }
            .aspectRatio(1.0, contentMode: .fill)
            .clipShape(.circle)
            
            VStack {
                Text(loginedInfo.userName)
                    .font(.title3.bold())
            }
            
            Spacer()
            
            Button {
                
            } label: {
                //Label("프로필 편집", image: "edit")
                Image("edit")
                    .padding()
                    .background(Color.staticGray6)
                    .clipShape(.rect(cornerRadius: 10))
            }
            .tint(.primary)
        }
    }
    
    private func presentToggle() {

    }
}

//#Preview {
//    NavigationStack {
//        MoreInfoView()
//    }
//}
