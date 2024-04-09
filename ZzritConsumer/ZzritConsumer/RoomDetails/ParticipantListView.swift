//
//  ParticipantListView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/9/24.
//

import SwiftUI

struct ParticipantListView: View {
    // 그리드 뷰에 나타낼 열의 개수
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    // 샘플 유저
    // TODO: 유저 모델 배열로 변경 필요
    let sampleUsers: [String] = ["정웅재", "박현상", "건강", "이준선"]
    
    // MARK: - body
    
    var body: some View {
        // 그리드 뷰: 열 2개
        LazyVGrid(columns: columns, alignment: .leading) {
            // TODO: 참가자 카운트로 변경 필요
            ForEach(sampleUsers, id: \.self) { user in
                // 참가자 셀 뷰
                // TODO: 이곳에 유저 정보 모델을 주입
                ParticipantListCellView(nickName: user)
                    .padding(.leading, 15)
                    .padding(.top, 15)
            }
        }
        .padding(.bottom, 15)
        .overlay {
            RoundedRectangle(cornerRadius: Configs.cornerRadius)
                .stroke(lineWidth: 1.0)
                .foregroundStyle(Color.staticGray4)
        }
    }
}

#Preview {
    ParticipantListView()
}
