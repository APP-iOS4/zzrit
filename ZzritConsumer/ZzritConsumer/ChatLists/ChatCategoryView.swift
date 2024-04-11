//
//  ChatCategoryView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/10/24.
//

import SwiftUI

struct ChatCategoryView: View {
    @State private var isShowingChat = true
    
    @Namespace private var namespace
    
    @Binding var selection: String
    
    let  chatCategory: [String] = ["참여 중인 모임", "종료된 모임"]
    
    var body: some View {
        HStack {
            ForEach(chatCategory, id: \.self) { category in
                ZStack(alignment: .center) {
                    Text("\(category)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(selection == category ? Color.pointColor : Color.staticGray1 )
                        .background{
                            if selection == category {
                                Rectangle()
                                    .foregroundStyle(isShowingChat ? Color.pointColor : .clear)
                                    .matchedGeometryEffect(id: "category", in: namespace)
                                    .frame(height: 1)
                                    .offset(y: 12)
                            }
                        }
                        .padding(EdgeInsets(top: 5, leading: 20, bottom: 10, trailing: 20))
                }
                .onTapGesture {
                    withAnimation(.spring()) {
                        selection = category
                    }
                }
            }
        }
    }
}

#Preview {
    ChatCategoryView(selection: .constant("참여 중인 모임"))
}
