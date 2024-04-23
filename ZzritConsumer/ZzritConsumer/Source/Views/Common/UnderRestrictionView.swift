//
//  UnderRestrictionView.swift
//  ZzritConsumer
//
//  Created by 이우석 on 4/22/24.
//

import SwiftUI

import ZzritKit

struct UnderRestrictionView: View {
    @EnvironmentObject private var userService: UserService
    @EnvironmentObject private var restrictionViewModel: RestrictionViewModel
    
    @Binding var userModel: UserModel?
    @State private var isQuestionShow = false
    
    private let dateService = DateService.shared
    
    private let columns: [GridItem] = [GridItem(.flexible(minimum: 120, maximum: 120)), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            VStack {
                if let user = userModel {
                    Text("\(user.userName)님은 현재 이용정지 상태입니다.\n제재 사유가 부적절하다면 아래 버튼을 눌러 문의해 주세요. ")
                        .font(.title2)
                        .padding(EdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 20))
                }
                
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        ForEach(restrictionViewModel.currentRestriction) { ban in
                            LazyVGrid(columns: columns, alignment: .leading) {
                                Text("제재 종류")
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.pointColor)
                                    .padding(.bottom, 5)
                                    .padding(.top, 13)
                                
                                Text(ban.type.rawValue)
                                    .foregroundStyle(Color.staticGray1)
                                    .padding(.bottom, 5)
                                    .padding(.top, 13)
                                
                                Text("제재 기간")
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.pointColor)
                                    .padding(.bottom, 5)
                                
                                Text("\(dateService.formattedString(date: ban.date, format: "yyyy년 M월 d일"))\n~ \(dateService.formattedString(date: ban.period, format: "yyyy년 M월 d일"))")
                                .foregroundStyle(Color.staticGray1)
                                .padding(.bottom, 5)
                                
                                Text("상세 사유")
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.pointColor)
                                    .padding(.bottom, 5)
                                
                                Text(ban.content)
                                    .foregroundStyle(Color.staticGray1)
                                    .padding(.bottom, 5)
                                
                                Text("정전기 지수 감소")
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.pointColor)
                                
                                Text("\(restrictionViewModel.getPenalty(from: ban.date, to: ban.period))W")
                                    .foregroundStyle(Color.staticGray1)
                            }
                            .padding(.horizontal, 13)
                            .padding(.bottom, 13)
                            .frame(maxWidth: .infinity)
                            .overlay {
                                RoundedRectangle(cornerRadius: Configs.cornerRadius)
                                    .strokeBorder(Color.staticGray4, lineWidth: 1.0)
                            }
                        }
                    }
                    .padding(20)
                }
                
                GeneralButton("문의하기") {
                    isQuestionShow.toggle()
                }
                .navigationDestination(isPresented: $isQuestionShow){
                    ContactView()
                }
                .padding(20)
                
            }
            .toolbar {
                // 왼쪽 앱 메인 로고
                ToolbarItem(placement: .topBarLeading) {
                    HStack(spacing: 0) {
                        Text("ZZ!")
                            .foregroundStyle(Color.pointColor)
                        Text("RIT")
                    }
                    .font(.title2)
                    .fontWeight(.black)
                }
                
                // 오른쪽 알림 창
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Button {
                            logout()
                        } label: {
                            Text("로그아웃")
                                .foregroundStyle(Color.staticGray2)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                Task {
                    userModel = try await userService.loggedInUserInfo()
                }
            }
        }
    }
    
    private func logout() {
        do {
            try AuthenticationService.shared.logout()
            restrictionViewModel.currentRestriction = []
            restrictionViewModel.restrictionHistory = []
        } catch {
            print("에러: \(error)")
        }
    }
}
