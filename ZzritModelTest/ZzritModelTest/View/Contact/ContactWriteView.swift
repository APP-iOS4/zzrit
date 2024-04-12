//
//  ContactWriteView.swift
//  ZzritModelTest
//
//  Created by Sanghyeon Park on 4/12/24.
//

import SwiftUI

import ZzritKit

struct ContactWriteView: View {
    private let contactService = ContactService()
    
    @State private var contactSubject: String = ""
    @State private var contactContent: String = ""
    private var categories: [ContactCategory] = ContactCategory.allCases
    @State private var selectedCategory: ContactCategory = .app
    
    var writeDisabled: Bool {
        return (contactSubject == "") || (contactContent == "")
    }
    
    var body: some View {
        Form {
            Section("문의 작성") {
                TextField("문의 제목", text: $contactSubject)
                TextEditor(text: $contactContent)
                    .overlay {
                        if contactContent == "" {
                            Text("문의 내용")
                                .foregroundStyle(.placeholder)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                Picker("문의 카테고리", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category.rawValue)
                            .tag(category)
                    }
                }
                Button("작성") {
                    writeContact()
                }
                .disabled(writeDisabled)
            }
        }
    }
    
    private func writeContact() {
        let requestedUser = "28IsmsvqGYd0DNrS3tjkuUVzr2l2"
        
        let tempModel: ContactModel = .init(category: selectedCategory, title: contactSubject, content: contactContent, requestedDated: Date(), requestedUser: requestedUser)
        
        do {
            try contactService.writeContact(tempModel)
            contactSubject = ""
            contactContent = ""
        } catch {
            print("에러: \(error)")
        }
    }
}

#Preview {
    ContactWriteView()
}