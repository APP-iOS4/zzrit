//
//  RoomCreateTextField.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/9/24.
//

import SwiftUI

struct RCTitleTextField: View {
    @Binding var text: String
    @FocusState private var focused: Bool
    let whenTextChange: () -> Void
    
    var body: some View {
        if #available(iOS 17.0, *) {
            // iOS 17.0 이상이라면
            TextField(
                "내용을 입력해주세요.",
                text: $text,
                prompt: Text("내용을 입력해주세요.")
                    .foregroundStyle(Color.staticGray2)
            )
            .onChange(of: text) {
                whenTextChange()
            }
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 8.0)
                    .stroke(Color.staticGray5, lineWidth: 1.0)
            }
        } else {
            // iOS 17.0 미만이라면
            TextField(
                "내용을 입력해주세요.",
                text: $text,
                prompt: Text("내용을 입력해주세요.")
                    .foregroundColor(Color.staticGray2)
            )
            .onChange(of: text, perform: { value in
                whenTextChange()
            })
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 8.0)
                    .stroke(Color.staticGray5, lineWidth: 1.0)
            }
        }
    }
}

#Preview {
    RCTitleTextField(text: .constant("")) {
        
    }
}
