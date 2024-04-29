//
//  ContactContentView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/9/24.
//

import SwiftUI

import ZzritKit

struct ContactContentView: View {
    @EnvironmentObject private var userService: UserService
    
    let contact: ContactModel
    
    // 임시 문의 종류 변수
    let contactCategory: ContactCategory = .room
    // 신고 대상 모임 이름
    @Binding var targetRoomName: String
    // 신고 대상 회원 닉네임
    @Binding var targetUserName: [String]
    
    var targetUserString: String {
        var tempString = "신고 대상 회원 : "
        
        for idx in targetUserName.indices {
            tempString += "\(targetUserName[idx])"
            
            if idx < targetUserName.count - 1 {
                tempString += ", "
            }
        }
        
        return tempString
    }
    // MARK: - body

    
    var body: some View {
        VStack(alignment: .leading) {
            // 문의 종류 카테고리 주입
            Text(contact.category.rawValue)
                .font(.footnote)
                .foregroundStyle(Color.pointColor)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // 문의내역 타이틀 주입
            Text(contact.title)
                .font(.title3)
            
            // 문의내역 답변상황 및 문의 등록 날짜
            HStack {
                // 문의 내역의 현재 상태
                Text(contact.isAnswered ? "답변완료" : "접수완료")
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .font(.footnote)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(lineWidth: 2.0)
                    }
                    .foregroundStyle(contact.isAnswered ? Color.pointColor : Color.staticGray3)
                    .background(contact.isAnswered ? Color.lightPointColor : .white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                // 문의 내역의 등록 날짜
                Text(DateService.shared.formattedString(date: contact.requestedDate))
                    .font(.footnote)
                    .foregroundStyle(Color.staticGray3)
            }
            .padding(.bottom, 30)
            
            //모임 제목을 주입
            if targetRoomName != "" {
                Text("신고 모임 : \(targetRoomName)")
                    .padding(.bottom, 5)
            }
            if !targetUserName.isEmpty {
                Text(targetUserString)
                    .padding(.bottom, 5)
            }
            
            // 문의 세부 내용을 주입
            Text(contact.content)
                .foregroundStyle(Color.staticGray2)
                .padding(.top, Configs.paddingValue)
        }
        .toolbarRole(.editor)
//        .onAppear {
//            fetchTargetRoom()
//        }
    }
    

    private func fetchTargetRoom() {
        if let targetRoom = contact.targetRoom, targetRoom != "" {
            Task {
                do {
                    targetRoomName = try await RoomService.shared.roomInfo(targetRoom)?.title ?? "(unknown)"
                } catch {
                    Configs.printDebugMessage("에러: \(error)")
                }
            }
        }
        
        if let targetUser = contact.targetUser, targetUser != [] {
            Task {
                targetUserName = []
                do {
                    for user in targetUser {
                        if user != "" {
                            let userModel = try await userService.findUserInfo(uid: user)
                            if let userName = userModel?.userName {
                                targetUserName.append(userName)
                            }
                        }
                    }
                } catch {
                    Configs.printDebugMessage("에러: \(error)")
                }
            }
        }
    }
}

//#Preview {
//    ContactContentView(isAnswered: true)
//}
