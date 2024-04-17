//
//  StaticGaugeEditingSubview.swift
//  ZzritAdministrator
//
//  Created by 이우석 on 4/11/24.
//

import SwiftUI

import ZzritKit

struct StaticGaugeEditingSubview: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @Binding var user: UserModel
    
    @State private var editAlert = false
    @State var indexAfterEdit: Double
    @Binding var isUserModal: Bool
    
    var body: some View {
        HStack {
            ProgressView(value: indexAfterEdit / 100)
            
            Text("\(String(format: "%.1f", indexAfterEdit))W")
            
            Spacer(minLength: 50)
            
            Button {
                if indexAfterEdit > 0{
                    indexAfterEdit -= 1
                }
            } label: {
                Image(systemName: "minus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            .buttonStyle(.bordered)
            
            Button {
                if indexAfterEdit < 100{
                    indexAfterEdit += 1
                }
            } label: {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            .buttonStyle(.bordered)
            
            Button {
                editAlert.toggle()
            } label: {
                Text("정전기 지수 수정하기")
                    .minimumScaleFactor(0.5)
                    .frame(height: 20)
            }
            .buttonStyle(.borderedProminent)
            .disabled(indexAfterEdit == user.staticGauge)
        }
        .alert("정전기 지수를 수정하시겠습니까?", isPresented: $editAlert) {
            Button("취소하기", role: .cancel){
                print("취소하기")
                editAlert.toggle()
            }
            Button("수정하기", role: .destructive){
                DispatchQueue.main.async {
                    if let id = user.id {
                        userViewModel.editScore(userID: id, score: Int(indexAfterEdit))
                    }
                    
                    userViewModel.loadUsers()
                    isUserModal.toggle()
                }
            }
        } message: {
            Text("대상자: \(user.userID)\n수정 전: \(String(format: "%.1f", user.staticGauge))W\n수정 후: \(String(format: "%.1f", indexAfterEdit))W")
        }
    }
}
