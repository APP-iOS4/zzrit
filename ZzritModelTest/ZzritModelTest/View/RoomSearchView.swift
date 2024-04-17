//
//  RoomSearchView.swift
//  ZzritModelTest
//
//  Created by woong on 4/17/24.
//

import SwiftUI

import ZzritKit

struct RoomSearchView: View {
    @State private var title = ""
    private let rs = RoomService.shared
    @State private var initial = true
    @State private var tempArr: [RoomModel] = []
    
    var body: some View {
        VStack {
            TextField("제목", text: $title)
                .padding(40)
            Button {
                Task {
                    do {
                        tempArr += try await rs.loadRoom(isInitial: initial, status: "all", title: title)
                        initial = false
                        print("title: \(title)")
                        print(type(of: title))
                        print(title.count)
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("불러오기")
            }
            List {
                ForEach(tempArr) { room in
                    NavigationLink {
                        Text(room.title)
                    } label: {
                        Text(room.title)
                    }
                }
            }
        }
        
    }
}

#Preview {
    RoomSearchView()
}
