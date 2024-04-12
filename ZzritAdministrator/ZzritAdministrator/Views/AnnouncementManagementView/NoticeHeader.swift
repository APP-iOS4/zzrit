//
//  AnnouncementHeader.swift
//  ZzritAdministrator
//
//  Created by Healthy on 4/9/24.
//

import SwiftUI

struct NoticeHeader: View {
    var body: some View {
        HStack {
            Text("제목")
                .frame(minWidth: 100, alignment: .center)
                .multilineTextAlignment(.center)
            
            Spacer()

            Divider()
            
            Text("공지 날짜")
                .frame(width: 150, alignment: .center)
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
    NoticeHeader()
}
