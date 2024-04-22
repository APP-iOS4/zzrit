//
//  RCContentTextFieldView.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/10/24.
//

import SwiftUI

struct RCContentTextField: View {
    @Binding var text: String
    @FocusState private var focused: Bool
    let whenTextChange: () -> Void
    
    var body: some View {
        if #available(iOS 17.0, *) {
            // iOS 17.0 이상이라면
            TextField(
                "모임에 대해 소개해주세요.",
                text: $text,
                prompt: Text("모임에 대해 소개해주세요.")
                    .foregroundStyle(Color.staticGray2),
                axis: .vertical
            )
            .onChange(of: text) {
                whenTextChange()
            }
            .lineLimit(5, reservesSpace: true)
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 8.0)
                    .strokeBorder(Color.staticGray5, lineWidth: 1.0)
            }
        } else {
            // iOS 17.0 미만이라면
            TextField(
                "모임에 대해 소개해주세요.",
                text: $text,
                prompt: Text("모임에 대해 소개해주세요.")
                    .foregroundColor(Color.staticGray2),
                axis: .vertical
            )
            .onChange(of: text, perform: { newValue in
                whenTextChange()
            })
            .lineLimit(5, reservesSpace: true)
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 8.0)
                    .strokeBorder(Color.staticGray5, lineWidth: 1.0)
            }
        }
    }
}

#Preview {
    RCContentTextField(text: .constant("")) {
        
    }
}
