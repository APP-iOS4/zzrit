//
//  PlaygroundSectionHeader.swift
//  ZzritAdministrator
//
//  Created by Healthy on 4/8/24.
//

import SwiftUI

struct PlaygroundSectionHeader: View {
    var body: some View {
        HStack {
            Text("모임 관리")
                .frame(minWidth: 100, alignment: .leading)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            Divider()
            
            Text("인원")
                .frame(width: 80, alignment: .leading)
                .multilineTextAlignment(.leading)
            
            Divider()
            
            Text(verbatim: "날짜")
                .frame(width: 90, alignment: .leading)
                .multilineTextAlignment(.leading)
            
            Divider()
            
            Text("활성화")
                .frame(width: 90, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
        .fontWeight(.bold)
        .foregroundStyle(Color.pointColor)
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
        .background {
            Rectangle()
                .foregroundStyle(Color.staticGray6)
        }
    }
}

#Preview {
    PlaygroundSectionHeader()
}
