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
            
            Text("인원 총/인원")
                .minimumScaleFactor(0.5)
                .frame(width: 90, alignment: .leading)
                .multilineTextAlignment(.leading)
            
            Divider()
            
            Text(verbatim: "날짜")
                .minimumScaleFactor(0.5)
                .frame(width: 90, alignment: .leading)
                .multilineTextAlignment(.leading)
            
            Divider()
            
            Text("활성화")
                .minimumScaleFactor(0.5)
                .frame(width: 90, alignment: .leading)
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
