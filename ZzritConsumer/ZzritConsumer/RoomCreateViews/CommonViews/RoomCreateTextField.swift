//
//  RoomCreateTextField.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/9/24.
//

import SwiftUI

struct RoomCreateTextField: View {
    let placeholder: String
    @State var text: String = ""
    var type: TextFieldType = .name
    
    var body: some View {
        if #available(iOS 17.0, *) {
            if type == .name {
                TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(Color.staticGray2))
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 8.0)
                            .stroke(Color.staticGray5, lineWidth: 1.0)
                    }
            } else {
                TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(Color.staticGray2), axis: .vertical)
                    .padding()
                    .frame(minHeight: 150.0, alignment: .topLeading)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8.0)
                            .stroke(Color.staticGray5, lineWidth: 1.0)
                    }
            }
            
        } else {
            if type == .name {
                // Fallback on earlier versions
                TextField("", text: $text, prompt: Text(placeholder).foregroundColor(Color.staticGray2))
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 8.0)
                            .stroke(Color.staticGray5, lineWidth: 1.0)
                    }
            } else {
                TextField("", text: $text, prompt: Text(placeholder).foregroundColor(Color.staticGray2), axis: .vertical)
                    .padding()
                    .frame(minHeight: 150.0, alignment: .topLeading)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8.0)
                            .stroke(Color.staticGray5, lineWidth: 1.0)
                    }
            }
        }
    }
    
    enum TextFieldType {
        case name
        case roomIntroduce
    }
}

#Preview {
    RoomCreateTextField(placeholder: "Hello", type: .roomIntroduce)
}
