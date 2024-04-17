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
    @Published var userModel: UserModel = .init(userID: "", userName: "", userImage: "", gender: .male, birthYear: 1900, staticGauge: 0, agreeServiceDate: Date(), agreePrivacyDate: Date(), agreeLocationDate: Date())
    @Published var targetRoomModel: RoomModel? = nil
    @Published var targetUserModels: [UserModel]? = nil
    @Published var replies: [ContactReplyModel] = []
    @Published var repliedAdmins: [AdminModel] = []
    
    var initialFetch: Bool = true
    private let contactService = ContactService()
    private let userService = UserService()
    private let roomService = RoomService.shared
    
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
            userModel = .init(userID: "", userName: "", userImage: "", gender: .male, birthYear: 1900, staticGauge: 0, agreeServiceDate: Date(), agreePrivacyDate: Date(), agreeLocationDate: Date())
            targetRoomModel = nil
            targetUserModels = nil
            repliedAdmins = []
            
            do {
                userModel = try await userService.getUserInfo(uid: contact.requestedUser) ?? .init(userID: "?", userName: "", userImage: "", gender: .male, birthYear: 1900, staticGauge: 0, agreeServiceDate: Date(), agreePrivacyDate: Date(), agreeLocationDate: Date())
                
                if let targetRoom = contact.targetRoom {
                    if !targetRoom.isEmpty {
                        targetRoomModel = try await roomService.roomInfo(targetRoom)
                    }
                    
                    if let targetUser = contact.targetUser {
                        targetUserModels = []
                        
                        for uid in targetUser {
                            if !uid.isEmpty {
                                targetUserModels?.append(try await userService.getUserInfo(uid: uid) ?? .init(userID: "?", userName: "", userImage: "", gender: .male, birthYear: 1900, staticGauge: 0, agreeServiceDate: Date(), agreePrivacyDate: Date(), agreeLocationDate: Date()))
                            }
                            print(uid)
                        }
                    }
                }
                
                replies = try await contactService.fetchReplies(contact.id ?? "").reversed()
                
                for reply in replies {
                    let admin = await getAdminsInfo(uid: reply.answeredAdmin)
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
    
    private func getAdminsInfo(uid: String) async -> AdminModel {
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
