//
//  ParticipantListView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/9/24.
//

import SwiftUI

import ZzritKit

struct ParticipantListView: View {
    @EnvironmentObject var userService: UserService
    // 그리드 뷰에 나타낼 열의 개수
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    
    let room: RoomModel
    
    let participants: [JoinedUserModel]
    
    @State private var getUserModels: [UserModel] = []

    // MARK: - body
    
    var body: some View {
        // 그리드 뷰: 열 2개
        if #available(iOS 17.0, *) {
            VStack(alignment: .leading) {
                // TODO: 참가자 카운트로 변경 필요
                ForEach(getUserModels) { userModel in
                    ParticipantListCellView(room: room, participant: userModel)
                        .padding(.leading, 15)
                        .padding(.top, 15)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 15)
            .overlay {
                RoundedRectangle(cornerRadius: Configs.cornerRadius)
                    .strokeBorder(Color.staticGray4, lineWidth: 1.0)
            }
            .onChange(of: participants.count) {
                Task {
                    try await getUsersInfo()
                }
            }
        } else {
            VStack(alignment: .leading) {
                // TODO: 참가자 카운트로 변경 필요
                ForEach(getUserModels) { userModel in
                    ParticipantListCellView(room: room, participant: userModel)
                        .padding(.leading, 15)
                        .padding(.top, 15)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 15)
            .overlay {
                RoundedRectangle(cornerRadius: Configs.cornerRadius)
                    .strokeBorder(Color.staticGray4, lineWidth: 1.0)
            }
            .onChange(of: participants.count) { newValue in
                Task {
                    try await getUsersInfo()
                }
            }
        }
    }
    
    func getUsersInfo() async throws {
        do {
            for participant in participants {
                
                guard let userInfo =  try await userService.getUserInfo(uid: participant.userID)
                else { return }

                getUserModels.append(userInfo)
            }
        } catch {
            throw error
        }
    }
}

#Preview {
    ParticipantListView(room: RoomModel(title: "같이 모여서 가볍게 치맥하실 분...", category: .hobby, dateTime: Date(), content: "", coverImage: "https://picsum.photos/200", isOnline: false, status: .activation, leaderID: "", limitPeople: 8), participants: [JoinedUserModel()])
        .environmentObject(UserService())
}
