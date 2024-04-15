//
//  TermsAddingView.swift
//  ZzritAdministrator
//
//  Created by 이우석 on 4/15/24.
//

import SwiftUI

import ZzritKit

struct TermsAddingView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var termType: TermType = .privacy
    @State private var termsURLString: String = "https://"
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                TermsPickerView(selectedTerms: $termType)
                    .padding(8)
                    .overlay {
                        RoundedRectangle(cornerRadius: Constants.commonRadius)
                            .stroke(Color.staticGray3, lineWidth: 1.0)
                    }
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.app.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 43)
                        .foregroundStyle(Color.staticGray3)
                }
            }
            
            HStack {
                Text("URL: ")
                    .font(.title3.bold())
                TextField("약관 URL 주소를 입력해 주세요", text: $termsURLString)
                    .textInputAutocapitalization(.never)
                    .padding(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: Constants.commonRadius)
                            .stroke(Color.staticGray3, lineWidth: 1.0)
                    }
            }
            .padding(.vertical, 30)
            
            
            Spacer()
            
            MyButton(named: "등록") {
                
            }
        }
        .padding(20)
    }
}

#Preview {
    TermsAddingView()
}
