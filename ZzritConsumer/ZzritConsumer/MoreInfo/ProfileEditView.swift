//
//  ProfileEditView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/9/24.
//

import SwiftUI

struct ProfileEditView: View {
    var email: String
    var loginInfo: String
    @State var isEditAction = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(email)
                    .font(.title3)
                    .foregroundStyle(Color.staticGray1)
                Text(loginInfo)
                    .font(.callout)
                    .foregroundStyle(Color.staticGray3)
            }
            Spacer()
            Button {
                // TODO: 프로필 편집 화면 연결
                isEditAction.toggle()
            } label: {
                Image(systemName: "pencil.line")
                    .fontWeight(.medium)
                    .foregroundStyle(Color.staticGray3)
                    .frame(width: 30)
            }
        }
        .padding(Configs.paddingValue)
        .frame(maxWidth: .infinity)
        .background(Color.staticGray6)
        .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    NavigationStack {
        MoreInfoView()
    }
}
