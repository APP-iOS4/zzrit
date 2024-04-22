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
                HStack {
                    Button {
                        isTopTrailingAction.toggle()
                    } label: {
                        Image(systemName: "pencil.line")
                            .foregroundStyle(.black)
                    }
                    // 문의 내용 작성 뷰로 이동하는 navigationDestination
                    .navigationDestination(isPresented: $isTopTrailingAction) {
                        ContactInputView()
                    }
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
                if let userUID = try await userService.loginedUserInfo()?.id {
                    contacts = try await contactService.fetchContact(requestedUID: userUID)
                }
            } catch {
                print("에러: \(error)")
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
