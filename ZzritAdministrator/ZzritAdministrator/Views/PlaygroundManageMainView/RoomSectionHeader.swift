//
//  PlaygroundSectionHeader.swift
//  ZzritAdministrator
//
//  Created by Healthy on 4/8/24.
//

import SwiftUI

struct RoomSectionHeader: View {
    var body: some View {
        HStack {
            Text("모임 관리")
                .frame(minWidth: 100, alignment: .leading)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            Divider()
            
            Text("제한 인원")
                .frame(width: 90, alignment: .leading)
                .multilineTextAlignment(.leading)
            
            Divider()
            
            Text(verbatim: "모임 일시")
                .frame(width: 120, alignment: .leading)
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
    RoomSectionHeader()
}
