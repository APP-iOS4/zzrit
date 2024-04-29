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
    
    private var sortedUsers: [UserModel] {
        return getUserModels.sorted {
            if $0.id == room.leaderID {
                return true
            } else if $1.id == room.leaderID {
                return false
            }
            return $0.userName < $1.userName
        }
    }
    
    // MARK: - body
    
    var body: some View {
        // 그리드 뷰: 열 2개
        if #available(iOS 17.0, *) {
            VStack(alignment: .leading) {
                // TODO: 참가자 카운트로 변경 필요
                ForEach(sortedUsers) { userModel in
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
            var tempGetUserModels: [UserModel] = []
            for participant in participants {
                
                guard let userInfo =  try await userService.findUserInfo(uid: participant.userID)
                else { return }
                
                tempGetUserModels.append(userInfo)
            }
            
            getUserModels = tempGetUserModels
        } catch {
            throw error
        }
    }
}

#Preview {
    ParticipantListView(room: RoomModel(title: "같이 모여서 가볍게 치맥하실 분...", category: .hobby, dateTime: Date(), content: "", coverImage: "https://picsum.photos/200", isOnline: false, status: .activation, leaderID: "", limitPeople: 8, scoreLimitaion: 40, genderLimitation: .female), participants: [JoinedUserModel()])
        .environmentObject(UserService())
}
