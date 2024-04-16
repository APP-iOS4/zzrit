//
//  ContactViewModel.swift
//  ZzritAdministrator
//
//  Created by 이우석 on 4/16/24.
//

import Foundation
import ZzritKit

@MainActor
class ContactViewModel: ObservableObject {
    @Published var contacts: [ContactModel] = []
    var initialFetch: Bool = true
    private let contactService = ContactService()
    
    init() {
        loadContacts()
        initialFetch = false
    }
    
    func loadContacts() {
        Task {
            do {
                contacts += try await contactService.fetchContact(isInitialFetch: initialFetch)
            } catch {
                print("에러: \(error)")
            }
        }
    }
}
