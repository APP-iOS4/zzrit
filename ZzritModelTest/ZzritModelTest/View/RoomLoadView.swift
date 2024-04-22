//
//  RoomLoadView.swift
//  ZzritModelTest
//
//  Created by woong on 4/11/24.
//

import SwiftUI

import ZzritKit

struct RoomLoadView: View {
    let rs: RoomService = RoomService.shared
    @State private var allRooms: [RoomModel] = []
    @State private var roomID = ""
    @State private var title = ""
    @State private var isInitial = true
    
    var body: some View {
        VStack {
            TextField("모임 제목", text: $title)
                .padding()
            Button {
                Task {
                    do {
                        allRooms = try await rs.loadRoom(isInitial: isInitial)
                        isInitial = false
                        print("룸 로드 쿼리 날라감")
                    } catch FirebaseErrorType.failLoadRoom {
                        print("룸 로드 실패")
                    }
                }
            } label: {
                Text("모임 불러오기")
            }
            
            NavigationStack{
                List {
                    ForEach(allRooms) { roomDetail in
                        
                        NavigationLink(roomDetail.title) {
                        
                            RoomModiView(passedRoomID: roomDetail.id!)
                            
                            
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    RoomLoadView()
}
