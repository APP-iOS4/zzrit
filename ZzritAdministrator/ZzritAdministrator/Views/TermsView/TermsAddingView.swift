//
//  TermsAddingView.swift
//  ZzritAdministrator
//
//  Created by 이우석 on 4/15/24.
//

import SwiftUI

import ZzritKit

struct TermsAddingView: View {
    
    @EnvironmentObject private var termsViewModel: TermsViewModel
    @Environment(\.dismiss) private var dismiss
    
    @Binding var termType: TermType
    
    @State private var termsURLString: String = "https://"
    @State private var showConfirmAlert: Bool = false
    
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
                showConfirmAlert.toggle()
            }
        }
        .padding(20)
        .alert("새로운 약관을 등록하시겠습니까?", isPresented: $showConfirmAlert) {
            Button("취소", role: .cancel){
                print("취소하기")
                showConfirmAlert.toggle()
            }
            Button("등록"){
                termsViewModel.addTerms(term: .init(date: Date(), urlString: termsURLString, type: termType))
                showConfirmAlert.toggle()
                dismiss()
            }
        }
    }
}

#Preview {
    TermsAddingView(termType: .constant(.location))
}
