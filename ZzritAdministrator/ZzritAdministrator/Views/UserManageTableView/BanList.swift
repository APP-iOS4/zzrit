//
//  BanList.swift
//  ZzritAdministrator
//
//  Created by 이우석 on 4/17/24.
//

import SwiftUI

import ZzritKit


struct BanList: View {
    @ObservedObject var userViewModel: UserViewModel
    @Binding var user: UserModel
    
    private let dateService = DateService.shared
    
    @State private var banDeleteAlert: Bool = false
    @State private var selectedBan: BannedModel? = nil
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if userViewModel.restrictionHistory.isEmpty {
                    Text("제재 이력이 없습니다. ")
                        .foregroundStyle(Color.staticGray2)
                } else {
                    ForEach(userViewModel.restrictionHistory) { ban in
                        BanListCell(bannedModel: ban, banDeleteAlert: $banDeleteAlert, selectedBan: $selectedBan)
                    }
                }
            }
            .padding(10)
        }
        .refreshable {
            if let id = user.id {
                userViewModel.loadBannedHistory(userID: id)
            }
        }
        .onAppear {
            if let id = user.id {
                userViewModel.loadBannedHistory(userID: id)
            }
        }
        .alert("제재를 삭제하시겠습니까?", isPresented: $banDeleteAlert) {
            Button("취소하기", role: .cancel){
                print("취소하기")
                banDeleteAlert.toggle()
            }
            Button("제재 삭제", role: .destructive){
                if let id = user.id {
                    if let banID = selectedBan?.id {
                        print("\(id) \(banID)")
                        userViewModel.deleteRestriction(userID: id, restrictionID: banID)
                    }
                }
            }
        } message: {
            Text("""
                 이메일 주소: \(user.userID)
                 제재 시작 일자: \(dateService.formattedString(date: selectedBan?.date ?? Date(), format: "yyyy/MM/dd HH:mm"))
                 제재 기간: \(Calendar.current.dateComponents([.day], from: selectedBan?.date ?? Date(), to: selectedBan?.period ?? Date()).day ?? 0)일
                 """)
        }
    }
}

struct BanListCell: View {
    let bannedModel: BannedModel

    private let dateService = DateService.shared
    
    @Binding var banDeleteAlert: Bool
    @Binding var selectedBan: BannedModel?
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(dateService.formattedString(date: bannedModel.date, format: "yyyy/MM/dd HH:mm"))
                        .fontWeight(.bold)
                    HStack(spacing: 20) {
                        Text("\(Calendar.current.dateComponents([.day], from: bannedModel.date, to: bannedModel.period).day ?? 0)일 제재")
                            .fontWeight(.bold)
                            .foregroundStyle(Color.pointColor)
                        Text("\(bannedModel.type.rawValue)")
                        Text("\(bannedModel.content)")
                            .foregroundStyle(Color.staticGray3)
                    }
                }
                
                Spacer()
                
                Button {
                    selectedBan = bannedModel
                    banDeleteAlert.toggle()
                } label: {
                    Text("제재 삭제")
                }
            }
            .padding(10)
            
            Divider()
        }
    }
}
