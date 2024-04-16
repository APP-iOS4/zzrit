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
    @Published var replies: [ContactReplyModel] = []
    @Published var repliedAdmins: [AdminModel] = []
    
    var initialFetch: Bool = true
    private let contactService = ContactService()
    private let authService = AuthenticationService.shared
    private let userService = UserService()
    
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
    
    func fetchReplies(contact: ContactModel) {
        Task {
            repliedAdmins = []
            
            do {
                replies = try await contactService.fetchReplies(contact.id ?? "").reversed()
                for reply in replies {
                    let admin = await getAdminInfo(uid: reply.answeredAdmin)
                    
                    print(admin)
                    
                    repliedAdmins.append(admin)
                }
            } catch {
                print("에러: \(error)")
            }
        }
    }
    
    func replyContact(contact: ContactModel, replyContent: String) {
        Task {
            do {
                if let admin = try await userService.loginedAdminInfo() {
                    let tempModel: ContactReplyModel = .init(date: Date(), content: replyContent, answeredAdmin: admin.id ?? "")
                    
                    try contactService.writeReply(tempModel, contactID: contact.id ?? "")
                    replies.append(tempModel)
                    repliedAdmins.append(admin)
                }
            } catch {
                print("에러: \(error)")
            }
        }
    }
    
    func getAdminInfo(uid: String) async -> AdminModel {
        var adminModel = AdminModel(name: "", email: "", level: .normal)
        
        
        do {
            adminModel = try await userService.getAdminInfo(uid: uid) ?? .init(name: "", email: "", level: .normal)
            
            return adminModel
        } catch {
            print("에러: \(error)")
            
            return AdminModel(name: "", email: "", level: .normal)
        }
    }
}
