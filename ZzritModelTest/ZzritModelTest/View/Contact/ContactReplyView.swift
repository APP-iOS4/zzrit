//
//  ContactReplyView.swift
//  ZzritModelTest
//
//  Created by Sanghyeon Park on 4/12/24.
//

import SwiftUI

import ZzritKit

struct ContactReplyView: View {
    private let contactService = ContactService()
    
    var contact: ContactModel
    
    @State private var replyContent: String = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack {
                    Text(contact.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(contact.content)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                
                Rectangle()
                    .foregroundStyle(.gray)
                    .frame(height: 10)
                
                TextEditor(text: $replyContent)
                    .overlay {
                        Text("답변 내용을 입력하세요.")
                            .foregroundStyle(.placeholder)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(minHeight: 50)
                
                Button {
                    replyContact()
                } label: {
                    Text("답변 등록")
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
    }
    
    private func replyContact() {
        do {
            let requestAdmin = "SfJgMVKNFYTKQw36HPcd0Rc8GTo1"
            let tempModel: ContactReplyModel = .init(date: Date(), content: replyContent, answeredAdmin: requestAdmin)
            
            try contactService.writeReply(tempModel, contactID: contact.id!)
        } catch {
            print("에러: \(error)")
        }
    }
}
