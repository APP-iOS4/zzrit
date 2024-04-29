//
//  SecessionCancelView.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/29/24.
//

import SwiftUI

import ZzritKit

struct SecessionCancelView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userService: UserService
    
    @State private var isShowingSecessionCancelAlert: Bool = false
    
    var secessionDateString: String {
        if let secessionDate = AuthenticationService.shared.secessionDate {
            return DateService.shared.formattedString(date: secessionDate, format: "yyyy년 M월 d일")
        }
        return "알 수 없음"
    }
    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                Image("ZziritLogoImage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                
                VStack(spacing: 40) {
                    VStack(spacing: 10) {
                        Text("해당 계정은 회원탈퇴 처리중 입니다.")
                        
                        HStack(spacing: 0) {
                            Text("회원탈퇴일자 : ")
                            Text(secessionDateString)
                                .foregroundStyle(Color.pointColor)
                        }
                        .fontWeight(.bold)
                    }
                    .font(.title3)
                    .foregroundStyle(Color.staticGray1)
                    
                    Text("회원탈퇴일자로부터 7일의 유예기간 동안\n회원 탈퇴를 철회하실 수 있습니다.")
                        .multilineTextAlignment(.center)
                }
            }
            
            Spacer()
            
            VStack {
                GeneralButton("회원탈퇴 철회") {
                    isShowingSecessionCancelAlert.toggle()
                }
            }
            .padding(.horizontal, Configs.paddingValue)
            .padding(.vertical, 10)
        }
        .alert("회원탈퇴 철회", isPresented: $isShowingSecessionCancelAlert) {
            Button(role: .cancel) {
                
            } label: {
                Text("취소")
            }
            Button("철회") {
                secessionCancel()
            }
        } message: {
            Text("철회 이후에는 다시 로그인하여 찌릿 이용이 가능합니다. 철회 하시겠습니까?")
        }

    }
    
    private func secessionCancel() {
        Task {
            do {
                try await userService.secessionCancel()
                dismiss()
            } catch {
                print("에러: \(error)")
            }
        }
    }
}
