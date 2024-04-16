//
//  UserManagingView.swift
//  ZzritModelTest
//
//  Created by woong on 4/15/24.
//

import SwiftUI

import ZzritKit

struct UserManagingView: View {
    
    private let userManager = UserManageService()
    private let userId = "Zh9BzI2HVDVOoKN0jAc2dtvMNy72"
    private let bannedHistoryId = "dtYJwnTIE9DF4TbRXDW0"
    
    @State private var emailString = ""
    @State private var newScore = ""
    private let someDateString = "2024-03-02 21:33:20"
    
    @State private var tempRestrictionLists: [BannedModel] = []
    
    var body: some View {
        
            List {
                HStack {
                    Text("이메일")
                    TextField("바꿀 이메일", text: $emailString)
                }
                
                Button {
                    userManager.changeUserEmail(userID: userId, newEmail: emailString)
                } label: {
                    Text("이메일 바꾸기")
                }
                
                HStack {
                    Text("유저 제제 등록")
                    Button {
                        Task {
                            do {
                                var someDate = someDateString.toDate()
                                try userManager.registerUserRestriction(userID: userId, adminID: "123123", bannedType: .abuse, period: someDate!, content: "aasdf")
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        Text("제재 등록")
                    }
                }
                
                HStack {
                    Text("유제 제제 해제")
                    Button {
                        userManager.deleteUserRestriction(userID: userId, bannedHistoryId: bannedHistoryId)
                        print("삭제 실행됨")
                    } label: {
                        Text("제재 해제")
                    }
                }
                
                HStack {
                    Text("유저 정전기 지수 수정")
                    TextField("바꿀 점수", text: $newScore)
                }
            }
            
            List {
                ForEach(tempRestrictionLists) { document in
                    Button {
                        
                    } label: {
                        Text(document.id ?? "실패")
                    }
                }
            }
            .onAppear {
                Task {
                    do {
//                        뷰 로드시마다 쿼리 날라가서 필요하면 주석 해제후 사용
//                        tempRestrictionLists =  try await userManager.loadRestrictions(userID: userId)
                    } catch {
                        print(error)
                    }
                }
            }
            
    }
}

#Preview {
    UserManagingView()
}
