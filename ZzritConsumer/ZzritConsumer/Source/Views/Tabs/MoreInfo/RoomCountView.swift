//
//  RoomCountView.swift
//  ZzritConsumer
//
//  Created by woong on 4/30/24.
//

import SwiftUI

import ZzritKit

struct RoomCountView: View {
    @EnvironmentObject private var us: UserService
    @EnvironmentObject var purchaseViewModel: PurchaseViewModel
    
    @State private var createdRoomCount: Int = 0
    
    var body: some View {
        
        VStack{
            if purchaseViewModel.isPurchased {
                HStack {
                    Spacer()
                    Text("👑 찌릿 Pro 구독 중! 👑")
                        .foregroundStyle(Color.pointColor)
                    Spacer()
                }
                .padding()
            } else {
                Button {
                    purchaseViewModel.togglePresent()
                } label: {
                    HStack{
                        Spacer()
                        VStack {
                            Text("찌릿 Pro 구독하기!")
                            Spacer()
                            HStack {
                                Text("남은 모임 생성 횟수")
                                Text("\(5 - createdRoomCount)")
                            }
                            .font(.caption)
                        }
                        Spacer()
                    }
                    .padding()
                }
                .background(Color(red: 255.0 / 255.0, green: 236.0 / 255.0, blue: 238.0 / 255.0))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: .staticGray4, radius: 3)
            }
        }
        .onAppear {
            Task {
                createdRoomCount = await us.createdRoomsCount((us.loginedUser?.id)!)
            }
        }
    }
}

#Preview {
    RoomCountView()
        .environmentObject(UserService())
        .environmentObject(PurchaseViewModel())
}
