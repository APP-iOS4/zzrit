//
//  MoreInfoListView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/9/24.
//

import SwiftUI

import ZzritKit
import FirebaseMessaging

struct MoreInfoListView: View {
    @EnvironmentObject private var notificationViewModel: NotificationViewModel
    
    @State private var isNoticeShow = false
    @State private var isQuestionShow = false
    @State private var isTermNavigationDestination: Bool = false
    @State private var selectedTermType: TermType = .service
    @State private var isShowingAlert: Bool = false
    
    @Binding var loginedInfo: UserModel?
    
    var isLogined: Bool
    
    var body: some View {
        VStack {
            FakeDivider()
            // Section 1
            VStack(alignment: .leading, spacing: 40) {
                // 공지사항
                Button {
                    isNoticeShow.toggle()
                } label: {
                    HorizontalLabel(string: "공지사항")
                }
                .navigationDestination(isPresented: $isNoticeShow){
                    NoticeListView()
                }
                // 버전 정보
                HStack {
                    Text("버전 정보")
                    Spacer()
                    Text("최신 버전")
                        .foregroundStyle(Color.staticGray4)
                }
                
                // TODO: FAQ 넣을것인가 그것이 문제로다
                
                //                    // 자주 묻는 질문
                //                    Button {
                //
                //                    } label: {
                //                        HorizontalLabel(string: "자주 묻는 질문")
                //
                //                    }
                // 문의하기
                if isLogined {
                    NavigationLink {
                        ContactView()
                    } label: {
                        HorizontalLabel(string: "문의하기")
                    }
                }
            }
            .padding(Configs.paddingValue)
            FakeDivider()
            // Section 2
            VStack(alignment: .leading, spacing: 40) {
                ForEach(TermType.allCases, id: \.self) { type in
                    Button {
                        selectedTermType = type
                        isTermNavigationDestination.toggle()
                    } label: {
                        HorizontalLabel(string: type.title)
                    }
                }
                
            }
            .padding(Configs.paddingValue)
            if isLogined {
                FakeDivider()
                // Section 3
                VStack(alignment: .leading, spacing: 40) {                    
                    // 로그아웃
                    Button {
                        isShowingAlert.toggle()
                    } label: {
                        HorizontalLabel(string: "로그아웃")
                            .foregroundStyle(.red)
                    }
                }
                .padding(Configs.paddingValue)
            }
        }
        .foregroundStyle(Color.staticGray1)
        .navigationDestination(isPresented: $isTermNavigationDestination) {
            TermView(type: selectedTermType)
        }
        .alert("로그아웃", isPresented: $isShowingAlert) {
            Button(role: .destructive) {
                logout()
            } label: {
                Text("로그아웃")
            }
            
        } message: {
            Text("정말 로그아웃 하시겠습니까?")
        }
    }
    
    private func logout() {
        DispatchQueue.main.async {
            do {
                Messaging.messaging().token { token, error in
                    if let error = error {
                        Configs.printDebugMessage("Error fetching FCM registration token: \(error)")
                    } else if let token = token {
                        if let uid = loginedInfo?.id {
                            PushService.shared.deleteToken(uid, token: token)
                            loginedInfo = nil
                            notificationViewModel.removeAllNotification()
                        }
                    }
                }
                
                try AuthenticationService.shared.logout()
            } catch {
                Configs.printDebugMessage("에러: \(error)")
            }
        }
    }
}

//#Preview {
//    MoreInfoListView( isLogined: true)
//}
