//
//  MyStaticGuageView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/9/24.
//

import SwiftUI

struct MyStaticGuageView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("나의 정전기 지수")
                .font(.title2)
            
            // TODO: (staticGuage: 66) 사용자의 정전기지수 넣어주기
            // 애니메이션 효과 넣어주기
            
            StaticGuageProgressView(staticGuage: 0)
            VStack(alignment: .center) {
                Text("정전기 지수가 낮으면 사람들과 연결되기 힘들어요!")
                Text("낮아지지 않도록 매너있게 행동합시다!")
            }
            .font(.footnote)
            .foregroundStyle(Color.staticGray2)
            .padding(Configs.paddingValue)
            .frame(maxWidth: .infinity)
            .background(Color.staticGray6)
            .clipShape(.rect(cornerRadius: Configs.cornerRadius))
        }
    }
}

#Preview {
    MyStaticGuageView()
}
