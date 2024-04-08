//
//  UserManageTableView.swift
//  ZzritAdministrator
//
//  Created by Healthy on 4/8/24.
//

import SwiftUI

import ZzritKit

struct UserManageTableView: View {
    let genderList: [GenderType] = [.male, .female]
    
    @State var selection: TempUser.ID? = nil
    @State var isFilterActive: Bool = true
    @State var isUserModal: Bool = false
    @State var genderSelection: GenderType? = nil
    
    @State private var userData: [TempUser] = users
    
    var body: some View {
        VStack {
            if isFilterActive {
                HStack {
                    
                    
                    Button {
                        userData = userData.sorted{ $0.staticIndex < $1.staticIndex }
                    } label: {
                        Text("정전기 지수")
                            .font(.title2)
                            .padding(10)
                    }
                    .buttonBorderShape(.roundedRectangle)
                    .buttonStyle(.borderedProminent)
                    
                    
                    Button {
                        userData = userData.sorted{ $0.birthYear < $1.birthYear }
                    } label: {
                        Text("출생 연도")
                            .font(.title2)
                            .padding(10)
                    }
                    .buttonBorderShape(.roundedRectangle)
                    .buttonStyle(.borderedProminent)
                    
                    Spacer()
                    
                    Text("성별")
                        .font(.title)
                        .padding(10)
                    
                    Button {
                        genderSelection = nil
                    } label: {
                        Text("전체")
                            .padding(.horizontal, 5)
                    }
                    .buttonBorderShape(.roundedRectangle)
                    .buttonStyle(.borderedProminent)
                    
                    Picker("성별", selection: $genderSelection) {
                        ForEach(genderList, id: \.self) { gender in
                            Text(gender.rawValue)
                                .tag(Optional(gender))
                        }
                    }
                    .frame(maxWidth: 300, maxHeight: 50)
                    .pickerStyle(.segmented)
                    .onChange(of: genderSelection) { _ in
                        guard let genderSelection else {
                            userData = users
                            return
                        }
                        userData = users.filter{ $0.gender == genderSelection }
                    }
                }
                .padding()
            }
            // MARK: -
            Table(userData, selection: $selection) {
                TableColumn("이메일", value: \.userID)
                TableColumn("정전기 지수") { user in
                    Text("\(user.staticIndex)")
                }
                .width(max: 200.0)
                TableColumn("출생연도") { user in
                    Text(verbatim: "\(user.birthYear)")
                }
                .width(max: 200.0)
                TableColumn("성별", value:\.gender.rawValue)
                    .width(max: 140.0)
            }
            .border(.black)
            .padding(20.0)
            
            HStack {
                Button {
                    
                } label: {
                    Text("데이터 더 불러오기")
                }
                .padding(20.0)
                
                
                Spacer()
                
                MyButton(named: "유저 제재하기", features: {
                    if selection != nil {
                        print("\(selection ?? UUID())")
                        isUserModal.toggle()
                    }
                }, width: 350.0)
                .frame(maxWidth: .infinity, alignment: .bottomTrailing)
            }
        }
        .tint(.pointColor)
        .fullScreenCover(isPresented: $isUserModal, content: {
            UserInfoModalView(isUserModal: $isUserModal, user: users.filter{$0.id == selection}.first!)
        })
        .padding()
    }
}

struct MyButton: View {
    var named: String = "My Button"
    
    var features: () -> Void = {
        print("My Button Features!!")
    }
    
    var width: CGFloat = .infinity
    var height: CGFloat = 50.0
    
    var body: some View {
        Button {
            features()
        } label: {
            Text("\(named)")
                .foregroundStyle(.white)
                .font(.title2)
                .frame(minWidth: 300.0, maxWidth: .infinity, minHeight: 40.0, maxHeight: .infinity)
                .frame(width: width, height: height)
                .background(Color.pointColor)
                .clipShape(.rect(cornerRadius: 60))
        }
    }
}


struct TempUser: Identifiable {
    var id: UUID = UUID()
    
    let userID: String
    let staticIndex: Int
    let birthYear: Int
    let gender: GenderType
}

private var users: [TempUser] = [
    TempUser(userID: "user1@gmail.com", staticIndex: 23, birthYear: 1827, gender: .male),
    TempUser(userID: "user2@gmail.com", staticIndex: 53, birthYear: 1879, gender: .female),
    TempUser(userID: "user3@gmail.com", staticIndex: 31, birthYear: 1867, gender: .male),
    TempUser(userID: "user4@gmail.com", staticIndex: 23, birthYear: 1995, gender: .female),
    TempUser(userID: "user5@gmail.com", staticIndex: 87, birthYear: 2001, gender: .male),
    TempUser(userID: "user6@gmail.com", staticIndex: 86, birthYear: 1998, gender: .male),
    TempUser(userID: "user7@gmail.com", staticIndex: 54, birthYear: 1999, gender: .female),
    TempUser(userID: "user1@gmail.com", staticIndex: 23, birthYear: 1827, gender: .male),
    TempUser(userID: "user2@gmail.com", staticIndex: 53, birthYear: 1879, gender: .female),
    TempUser(userID: "user3@gmail.com", staticIndex: 31, birthYear: 1867, gender: .male),
    TempUser(userID: "user4@gmail.com", staticIndex: 23, birthYear: 1995, gender: .female),
    TempUser(userID: "user5@gmail.com", staticIndex: 87, birthYear: 2002, gender: .male),
    TempUser(userID: "user6@gmail.com", staticIndex: 86, birthYear: 1996, gender: .male),
    TempUser(userID: "user7@gmail.com", staticIndex: 54, birthYear: 1997, gender: .female),
    TempUser(userID: "user1@gmail.com", staticIndex: 23, birthYear: 1827, gender: .male),
    TempUser(userID: "user2@gmail.com", staticIndex: 53, birthYear: 1879, gender: .female),
    TempUser(userID: "user3@gmail.com", staticIndex: 31, birthYear: 1867, gender: .male),
    TempUser(userID: "user4@gmail.com", staticIndex: 23, birthYear: 1995, gender: .female),
    TempUser(userID: "user5@gmail.com", staticIndex: 87, birthYear: 2003, gender: .male),
    TempUser(userID: "user6@gmail.com", staticIndex: 86, birthYear: 1994, gender: .male),
    TempUser(userID: "user7@gmail.com", staticIndex: 54, birthYear: 1993, gender: .female),
]


// MARK: 이 부분은 임시
// TODO: ZzritKit으로 옮길 예정
enum GenderType: String, Codable {
    case male = "남성"
    case female = "여성"
}


#Preview {
    UserManageTableView()
}
