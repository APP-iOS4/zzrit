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
                .frame(minWidth: 100, alignment: .center)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Divider()
            
            Text("인원")
                .frame(width: 80, alignment: .center)
                .multilineTextAlignment(.leading)
            
            Divider()
            
            Text(verbatim: "날짜")
                .frame(width: 90, alignment: .center)
                .multilineTextAlignment(.leading)
            
            Divider()
            
            Text("활성화")
                .frame(width: 90, alignment: .center)
                .multilineTextAlignment(.leading)
        }
        .fontWeight(.bold)
        .foregroundStyle(Color.pointColor)
        .padding(10)
        .background {
            Rectangle()
                .foregroundStyle(Color.staticGray6)
        }
    }
}

#Preview {
    PlaygroundSectionHeader()
}
