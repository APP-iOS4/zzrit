//
//  SearchField.swift
//  ZzritAdministrator
//
//  Created by Healthy on 4/8/24.
//

import SwiftUI
import ZzritKit

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
                    .background(Color.pointColor)
                    .clipShape(UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomTrailing: 10, topTrailing: 10)))
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: Constants.commonRadius)
                .stroke(Color.staticGray3, lineWidth: 1.0)
        }
    }
}

#Preview {
    SearchField(action: {
        
    })
}
