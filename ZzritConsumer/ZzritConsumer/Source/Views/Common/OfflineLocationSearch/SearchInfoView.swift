//
//  SearchInfoView.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/21/24.
//

import SwiftUI

struct SearchInfoView: View {
    var body: some View {
        ZStack {
            Color.staticGray6
            
            VStack(alignment: .leading, spacing: 20) {
                Text("이렇게 검색해 보세요")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title3.bold())
                
                HStack(alignment: .top) {
                    Text("\u{00B7}")
                        .fontWeight(.bold)
                    
                    VStack(alignment: .leading) {
                        Text("도로명 + 건물번호")
                        Text("예) 찌릿길 123")
                            .foregroundStyle(Color.staticGray2)
                    }
                }
                
                HStack(alignment: .top) {
                    Text("\u{00B7}")
                        .fontWeight(.bold)
                    
                    VStack(alignment: .leading) {
                        Text("지역명  + 번지")
                        Text("예) 찌릿동 12-3")
                            .foregroundStyle(Color.staticGray2)
                    }
                }
                
                HStack(alignment: .top) {
                    Text("\u{00B7}")
                        .fontWeight(.bold)
                    
                    VStack(alignment: .leading) {
                        Text("건물명, 아파트명")
                        Text("예) 찌릿빌딩")
                            .foregroundStyle(Color.staticGray2)
                    }
                }
                
                Spacer()
            }
            .padding(30)
        }
    }
}

#Preview {
    SearchInfoView()
}
