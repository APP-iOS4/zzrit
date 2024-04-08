//
//  SearchField.swift
//  ZzritAdministrator
//
//  Created by Healthy on 4/8/24.
//

import SwiftUI

struct SearchField: View {
    var placeHolder: String = "모임 이름을 입력하세요"
    @State var text: String = ""
    let action: () -> ()
    
    var body: some View {
        HStack {
            TextField(placeHolder, text: $text)
                .padding(10.0)
                .padding(.leading)
            Button {
                action()
            } label: {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.white)
                    .padding()
                    // TODO: 색상 변경해야 함
                    .background(Color.gray)
                    .clipShape(UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomTrailing: 10, topTrailing: 10)))
            }
        }
        .background {
            RoundedRectangle(cornerRadius: Constants.commonRadius)
                .foregroundStyle(.white)
                .shadow(radius: 10)
        }
    }
}

#Preview {
    SearchField(action: {
        
    })
}
