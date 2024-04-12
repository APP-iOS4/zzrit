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
    @State var allRooms: [RoomModel] = []
    @State private var roomID = ""
    
    var body: some View {
        VStack {
            Button {
                Task {
                    do {
                        allRooms = try await rs.loadRoom(isInitial: true)
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
