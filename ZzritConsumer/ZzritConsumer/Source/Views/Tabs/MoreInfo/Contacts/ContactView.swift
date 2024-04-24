//
//  ContactView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/9/24.
//

import SwiftUI

import ZzritKit

struct ContactView: View {
    @EnvironmentObject private var userService: UserService
    private let contactService = ContactService()
    
    // 문의 내용 작성 버튼을 눌렀는지
    @State private var isTopTrailingAction: Bool = false
    
    @State private var contacts: [ContactModel] = []
    
    //MARK: - body
    
    var body: some View {
        VStack {
            // 문의 목록 리스트 뷰
            ContactListView(contacts: contacts)
        }
        .toolbarRole(.editor)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    ContactInputView()
                } label: {
                    Image(systemName: "pencil.line")
                        .foregroundStyle(.black)
                }
            }
        }
        .onAppear {
            fetchContacts()
        }
    }
    
    private func fetchContacts() {
        Task {
            do {
                if let userUID = try await userService.loggedInUserInfo()?.id {
                    contacts = try await contactService.fetchContact(requestedUID: userUID)
                }
            } catch {
                Configs.printDebugMessage("에러: \(error)")
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContactView()
            .environmentObject(UserService())
    }
}
