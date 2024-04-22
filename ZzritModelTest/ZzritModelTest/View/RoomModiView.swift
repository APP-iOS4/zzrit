//
//  RoomModiView.swift
//  ZzritModelTest
//
//  Created by woong on 4/11/24.
//

import SwiftUI

import ZzritKit

struct RoomModiView: View {
    
    let rs = RoomService.shared
    
    @State var passedRoomID: String
    @State var title: String = ""
    @State var category: CategoryType = .art
    var categories: [CategoryType] = CategoryType.allCases.map { $0 }
    var dateTime = Date()
    var latitude = 37.8
    var longitude = 125.8
    @State private var content: String = ""
    @State private var imageURLString: String = "https://picsum.photos/200"
    @State private var isOnline: Bool = false
    @State var platform: PlatformType = .etc
    var platforms: [PlatformType] = PlatformType.allCases.map { $0 }
    @State private var leaderID: String = ""
    @State private var isActive: Bool = true
    @State private var activationType: ActiveType = .activation
    @State private var limitPeople: String = ""
    @State private var gender: Bool = false
    @State private var genderLimitation: GenderType = .female
    @State var score: Double = 0.0
    @State private var room: [String: Any] = [:]
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    HStack {
                        Text("제목")
                        TextField("제목", text: $title)
                    }
                    HStack {
                        Text("카테고리")
                        Picker("Choose a color", selection: $category) {
                            ForEach(categories, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(.wheel)
                    }
                    HStack {
                        Text("위도")
                        Text("\(latitude)")
                    }
                    HStack {
                        Text("경도")
                        Text("\(longitude)")
                    }
                    HStack {
                        Text("상세설명")
                        TextField("설명", text: $content)
                    }
                    HStack {
                        Text("커버이미지")
                        TextField("커버이미지", text: $imageURLString)
                    }
                    HStack {
                        Text("isOnline")
                        Toggle("온라인인가?", isOn: $isOnline)
                    }
                    if isOnline {
                        HStack {
                            Text("platform")
                            Picker("플랫폼선택", selection: $platform) {
                                ForEach(platforms, id: \.self) {
                                    Text($0.rawValue)
                                }
                            }
                            .pickerStyle(.wheel)
                        }
                    }
                    HStack {
                        Text("leaderID")
                        TextField("리더 아이디", text: $leaderID)
                    }
                    HStack {
                        Text("status")
                        Toggle("방이 살아있는지", isOn: $isActive)
                    }
                    HStack {
                        Text("limitPeople")
                        TextField("인원", text: $limitPeople)
                    }
                    HStack {
                        Text("genderLimitation")
                        Toggle("성별", isOn: $gender)
                            .onTapGesture {
                                if gender {
                                    genderLimitation = .female
                                } else {
                                    genderLimitation = .male
                                }
                            }
                    }
                    HStack {
                        Text("scoreLimitation")
                        Text("\(score)")
                        Slider(value: $score, in: 0...100, step: 1.0)
                    }
                    
                    
                }
                
                Button {
                    if isActive {
                        activationType = .activation
                    } else {
                        activationType = .deactivation
                    }
                    

//                    room = [
//                        "title": title,
//                        "category": category,
//                        "dateTime": Date(),
//                        "content": content,
//                        "coverImage": imageURLString,
//                        "isOnline": isOnline,
//                        "status": activationType,
//                        "leaderID": leaderID,
//                        "limitPeople": Int(limitPeople)!,
//                    ]
                    let aa = RoomModel(title: title, category: category, dateTime: Date(), content: content, coverImage: imageURLString, isOnline: isOnline, status: activationType, leaderID: leaderID, limitPeople: Int(limitPeople)!)
                    Task {
                        do {
                        try rs.modifyRoom(aa, roomID: passedRoomID)
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Text("데이터수정!")
                }
            }// 날짜 조절 불가, 시간만 가능
        }
    }
}

#Preview {
    RoomModiView(passedRoomID: "1234")
}
