//
//  ZziritUserVoteView.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/16/24.
//

import SwiftUI

import ZzritKit

struct ZziritUserVoteView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userService: UserService
    
    private let roomService = RoomService.shared
    
    let roomID: String
    
    private let gridColumns: [GridItem] = [
        .init(.flexible(), spacing: 30),
        .init(.flexible(), spacing: 30),
        .init(.flexible(), spacing: 30)
    ]
    
    @State private var roomTitle: String = ""
    @State private var userProfiles: [UserModel] = []
    
    @State private var selectedUsers: [String] = []
    
    var body: some View {
        Rectangle()
            .foregroundStyle(Color.init(uiColor: .systemBackground))
            .frame(height: 1)
        
        ScrollView {
            VStack(spacing: 20) {
                Text("모임이 끝났어요~")
                    .font(.title.bold())
                
                Text("이번 모임은 즐거우셨나요?\n찌릿했던 사람을 골라볼까요?")
                    .font(.title3)
                    .foregroundStyle(Color.staticGray2)
                    .multilineTextAlignment(.center)
                
                HStack {
                    Text("모임 :")
                        .foregroundStyle(Color.pointColor)
                        .fontWeight(.bold)
                    Text(roomTitle)
                        .lineLimit(1)
                        .foregroundStyle(.black)
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color.lightPointColor)
                }
                .clipShape(.rect(cornerRadius: 10))
            }
            .padding(Configs.paddingValue)
            
            LazyVGrid(columns: gridColumns, alignment: .leading, spacing: 40) {
                ForEach(userProfiles) { profile in
                    VoteProfileView(nickname: profile.userName, image: profile.userImage, selected: selectedUsers.contains(profile.id!))
                }
            }
            .padding(.top, Configs.paddingValue)
            .padding(.horizontal, Configs.paddingValue)
            .padding(.bottom, 100)
        }
        
        VStack {
            GeneralButton("확인") {
                applyEvaluate()
            }
        }
        .padding(.horizontal, Configs.paddingValue)
        .padding(.bottom, Configs.paddingValue)
        
        .onAppear {
            fetchVote()
        }
    }
    
    private func selectUser(userUID: String) {
        if selectedUsers.contains(userUID) {
            let index = selectedUsers.firstIndex(where: { $0 == userUID })!
            selectedUsers.remove(at: index)
        } else {
            selectedUsers.append(userUID)
        }
    }
    
    private func fetchVote() {
        Task {
            do {
                roomTitle = try await roomService.roomInfo(roomID).title
                
                if let myUID = try await userService.loginedUserInfo()?.id {
                    print(myUID)
                    let tempJoinedUsers = try await roomService.joinedUsers(roomID: roomID)
                    for joinedUser in tempJoinedUsers {
                        if joinedUser.userID != myUID {
                            if let userProfile = try await userService.getUserInfo(uid: joinedUser.userID) {
                                userProfiles.append(userProfile)
                            }
                        }
                    }
                }
            } catch {
                print("에러: \(error)")
            }
        }
    }
    
    private func applyEvaluate() {
        Task {
            do {
                try await userService.applyEvaluation(userUIDs: selectedUsers)
                dismiss()
            } catch {
                print("에러: \(error)")
            }
        }
    }
}

#Preview {
    ZziritUserVoteView(roomID: "1Ab05L2UJXVpbYD7qxNc")
        .environmentObject(UserService())
}
