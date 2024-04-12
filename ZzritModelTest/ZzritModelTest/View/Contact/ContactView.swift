//
//  ContactView.swift
//  ZzritModelTest
//
//  Created by Sanghyeon Park on 4/12/24.
//

import SwiftUI

import ZzritKit

struct ContactView: View {
    private let contactService = ContactService()
    
    @State private var contacts: [ContactModel] = []
    @State private var isInitial: Bool = true
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(contacts) { contact in
                    NavigationLink(contact.title) {
                        ContactReplyView(contact: contact)
                    }
                }
                .onDelete { indexSet in
                    deleteContact(indexSet: indexSet)
                }
            }
            .onAppear {
                fetchContacts()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink("등록") {
                        ContactWriteView()
                    }
                }
            }
        }
    }
    
    private func fetchContacts() {
        Task {
            do {
                print(isInitial)
                contacts += try await contactService.fetchContact(isInitialFetch: isInitial)
                isInitial = false
            } catch {
                print("에러: \(error)")
            }
        }
    }
    
    private func deleteContact(indexSet: IndexSet) {
        if let index = indexSet.first {
            contactService.deleteContact(contactID: contacts[index].id!)
        }
    }
}

#Preview {
    ContactView()
}
