//
//  SecessionView.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/29/24.
//

import SwiftUI

import ZzritKit

struct SecessionView: View {
    @EnvironmentObject private var userService: UserService
    @Environment(\.dismiss) private var dismiss
    
    @State private var isShowingSecessionAlert: Bool = false
    @State private var secessionReason: String = ""
    @State private var confirmSecession: Bool = false
    
    var confirmSymbol: String {
        if confirmSecession {
            return "checkmark.circle.fill"
        } else {
            return "checkmark.circle"
        }
    }
    
    var confirmSymbolColor: Color {
        if confirmSecession {
            return Color.pointColor
        } else {
            return Color.staticGray3
        }
    }
    
    var userNickname: String {
        if let userInfo = userService.loginedUser {
            return userInfo.userName
        } else {
            return "회원"
        }
    }
    
    var body: some View {
        NavigationStack {
            Rectangle()
                .foregroundStyle(.white)
                .frame(height: 1)
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading) {
                        Text("\(userNickname)님,")
                            .fontWeight(.medium)
                        Text("정말 탈퇴하시겠어요?")
                            .fontWeight(.bold)
                            .foregroundStyle(.red)
                    }
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        SecessionDescriptionView(description: "지금 탈퇴하시면 참여중인 모임에서 모두 탈퇴되며, 더이상 모임에 참여하실 수 없게 돼요!")
                        SecessionDescriptionView(description: "탈퇴 전, 회원님을 기다리는 모임 회원들을 위해 미리 말씀 해주세요.")
                        SecessionDescriptionView(description: "탈퇴 후 7일 전에 로그인하시면 회원탈퇴 철회가 가능하며, 이후에는 복구가 불가능합니다.")
                    }
                    
                    Button {
                        confirmSecession.toggle()
                    } label: {
                        HStack {
                            Image(systemName: confirmSymbol)
                                .foregroundStyle(confirmSymbolColor)
                            
                            Text("유의사항을 확인하였으며 동의합니다.")
                                .foregroundStyle(Color.staticGray2)
                        }
                    }
                    
                    VStack(spacing: 10) {
                        Text("떠나시는 이유를 알려주세요.")
                            .font(.title2)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        TextEditor(text: $secessionReason)
                            .padding(5)
                            .frame(height: 200)
                            .background {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(Color.staticGray6)
                                    if secessionReason == "" {
                                        VStack {
                                            Text("""
                                                서비스 탈퇴 사유에 대해 알려주세요.
                                                회원님의 소중한 피드백을 담아
                                                더 나은 모임이 될 수 있도록 노력하겠습니다.
                                                """)
                                            .foregroundStyle(Color.staticGray3)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .offset(x: 10, y: 13)
                                            
                                            Spacer()
                                        }
                                    }
                                }
                            }
                            .overlay {
                                
                            }
                            .scrollContentBackground(.hidden)
                    }
                }
                .padding(Configs.paddingValue)
            }
            
            VStack {
                GeneralButton("회원 탈퇴", isDisabled: !confirmSecession) {
                    isShowingSecessionAlert.toggle()
                }
                .padding(.horizontal, Configs.paddingValue)
                .padding(.vertical, 10)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3)
                    }
                    .tint(.primary)
                }
            }
            .navigationTitle("회원탈퇴")
            .navigationBarTitleDisplayMode(.inline)
        }
        .alert("회원탈퇴", isPresented: $isShowingSecessionAlert) {
            Button(role: .cancel) {
                
            } label: {
                Text("취소")
            }
            
            Button(role: .destructive) {
                secession()
            } label: {
                Text("회원탈퇴")
            }
        } message: {
            Text("정말로 탈퇴하시겠습니까?")
        }

    }
    
    private func secession() {
        Task {
            do {
                try await userService.secession(reason: secessionReason)
                try AuthenticationService.shared.logout()
                dismiss()
            } catch {
                print("에러: \(error)")
            }
        }
    }
}

struct SecessionDescriptionView: View {
    let description: String
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "exclamationmark.circle")
                .foregroundStyle(.red)
            Text(description)
        }
    }
}

#Preview {
    NavigationStack {
        SecessionView()
    }
}
