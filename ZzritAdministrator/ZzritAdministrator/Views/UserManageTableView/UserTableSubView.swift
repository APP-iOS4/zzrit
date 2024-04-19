//
//  UserTableSubView.swift
//  ZzritAdministrator
//
//  Created by 이우석 on 4/18/24.
//

import SwiftUI

import ZzritKit

struct UserTableSubView: View {
    var user: UserModel
    @Binding var selection: UserModel?
    
    var body: some View {
        HStack {
            Text("\(user.userID)")
                .minimumScaleFactor(0.5)
                .frame(minWidth: 200, alignment: .leading)
                .multilineTextAlignment(.leading)
            Spacer()
            
            Divider()
            
            Text("\(String(format: "%.1f", user.staticGauge))W")
                .minimumScaleFactor(0.5)
                .frame(width: 100, alignment: .leading)
                .multilineTextAlignment(.leading)
            
            Divider()
            
            Text(verbatim: "\(user.birthYear)년")
                .minimumScaleFactor(0.5)
                .frame(width: 120, alignment: .leading)
                .multilineTextAlignment(.leading)
            
            Divider()
            
            Text("\(user.gender.rawValue)")
                .minimumScaleFactor(0.5)
                .frame(width: 100, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
        .font(.title3)
        .foregroundStyle(user.id == selection?.id ? Color.pointColor : Color.primary)
        .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
    }
}
