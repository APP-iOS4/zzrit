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
    
    @State var selection: TempUser? = nil
    @State var isFilterActive: Bool = true
    @State var isUserModal: Bool = false
    @State var genderSelection: GenderType? = nil
    @State var isSortedByStatic: Bool = false
    @State var isSortedByYear: Bool = false
    @State private var searchText: String = ""
    
    @State private var userData: [TempUser] = users
    
    var body: some View {
        VStack {
            HStack(spacing: 20.0) {
                SearchField(placeHolder: "유저 이메일을 입력하세요.", text: searchText, action: {
                    print("검색")
                })
                Button {
                    print("필터 버튼 눌림")
                    isFilterActive.toggle()
                    isSortedByStatic = false
                    isSortedByYear = false
                    genderSelection = nil
                    userData = users
                } label: {
                    StaticTextView(title: "필터", selectType: .filter, width: 140.0, isActive: $isFilterActive)
                }
            }
            .padding(20.0)
            .fixedSize(horizontal: false, vertical: true)
            
            if isFilterActive {
                HStack {
                    Button {
                        userData = userData.sorted{ $0.staticIndex > $1.staticIndex }
                        isSortedByStatic = true
                        isSortedByYear = false
                    } label: {
                        StaticTextView(title: "정전기 지수", selectType: .filter, width: 140, isActive: $isSortedByStatic)
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    
                    
                    Button {
                        userData = userData.sorted{ $0.birthYear < $1.birthYear }
                        isSortedByStatic = false
                        isSortedByYear = true
                    } label: {
                        StaticTextView(title: "출생 연도", selectType: .filter, width: 140, isActive: $isSortedByYear)
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    
                    Spacer()
                    
                    Text("성별")
                        .font(.title)
                        .padding(10)
                    
                    Button {
                        genderSelection = nil
                    } label: {
                        StaticTextView(title: "전체", selectType: .filter, width: 80, isActive: .constant(genderSelection == nil))
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    
                    Button {
                        genderSelection = .male
                    } label: {
                        StaticTextView(title: "남성", selectType: .filter, width: 80, isActive: .constant(genderSelection == .male))
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    
                    Button {
                        genderSelection = .female
                    } label: {
                        StaticTextView(title: "여성", selectType: .filter, width: 80, isActive: .constant(genderSelection == .female))
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                }
                .padding()
            }
            // MARK: -
            //            Table(userData, selection: $selection) {
            //                TableColumn("이메일", value: \.userID)
            //                TableColumn("정전기 지수") { user in
            //                    Text("\(user.staticIndex)")
            //                }
            //                .width(max: 200.0)
            //                TableColumn("출생연도") { user in
            //                    Text(verbatim: "\(user.birthYear)")
            //                }
            //                .width(max: 200.0)
            //                TableColumn("성별", value:\.gender.rawValue)
            //                    .width(max: 140.0)
            //            }
            //            .border(.black)
            //            .padding(20.0)
            
            ScrollView {
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    Section(header: ScrollHeader())
                    {
                        ForEach(userData) { user in
                            Button {
                                selection = user
                            } label: {
                                HStack {
                                    Text(user.userID)
                                        .minimumScaleFactor(0.5)
                                        .frame(minWidth: 350, alignment: .leading)
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                    
                                    Divider()
                                    
                                    Text("\(user.staticIndex)W")
                                        .minimumScaleFactor(0.5)
                                        .frame(width: 100, alignment: .leading)
                                        .multilineTextAlignment(.leading)
                                    
                                    Divider()
                                    
                                    Text(verbatim: "\(user.birthYear)년")
                                        .minimumScaleFactor(0.5)
                                        .frame(width: 120, alignment: .leading)
                                        .multilineTextAlignment(.leading)
                                    
                                    Divider()
                                    
                                    Text("\(user.gender.rawValue)")
                                        .minimumScaleFactor(0.5)
                                        .frame(width: 100, alignment: .leading)
                                        .multilineTextAlignment(.leading)
                                }
                                .font(.title3)
                                .foregroundStyle(user == selection ? Color.pointColor : Color(uiColor: .label))
                                .padding(10)
                            }
                        }
                    }
                }
                .onChange(of: genderSelection) { _ in
                    guard let genderSelection else {
                        userData = users
                        return
                    }
                    userData = users.filter{ $0.gender == genderSelection }
                }
            }
            .listStyle(.plain)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            .overlay {
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                    .stroke(lineWidth: 2)
                    .foregroundStyle(Color.staticGray3)
            }
            .padding(20.0)
            
            HStack {
                Spacer()
                
                MyButton(named: "유저 제재하기", features: {
                    if selection != nil {
                        // print("\(selection ?? UUID())")
                        isUserModal.toggle()
                    }
                }, width: 350.0)
                .frame(maxWidth: .infinity, alignment: .bottomTrailing)
            }
        }
        .tint(.pointColor)
        .fullScreenCover(isPresented: $isUserModal, content: {
            UserInfoModalView(isUserModal: $isUserModal, user: selection ?? .init(userID: "NO DATA", staticIndex: 0, birthYear: 0, gender: .male))
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

struct ScrollHeader: View {
    
    var body: some View {
        HStack {
            Text("유저 이메일")
                .minimumScaleFactor(0.5)
                .frame(minWidth: 350, alignment: .leading)
                .multilineTextAlignment(.leading)
            
            Spacer()
            Divider()
            
            Text("정전기 지수")
                .minimumScaleFactor(0.5)
                .frame(width: 100, alignment: .leading)
                .multilineTextAlignment(.leading)
            
            Divider()
            
            Text(verbatim: "출생 연도")
                .minimumScaleFactor(0.5)
                .frame(width: 120, alignment: .leading)
                .multilineTextAlignment(.leading)
            
            Divider()
            
            Text("성별")
                .minimumScaleFactor(0.5)
                .frame(width: 100, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
        .fontWeight(.bold)
        .foregroundStyle(Color.pointColor)
        .padding(10)
        .background {
            Rectangle()
                .foregroundStyle(Color.staticGray6)
        }
    }
}


struct TempUser: Identifiable, Equatable {
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
    TempUser(userID: "user8@gmail.com", staticIndex: 23, birthYear: 1827, gender: .male),
    TempUser(userID: "user9@gmail.com", staticIndex: 53, birthYear: 1879, gender: .female),
    TempUser(userID: "user10@gmail.com", staticIndex: 31, birthYear: 1867, gender: .male),
    TempUser(userID: "user11@gmail.com", staticIndex: 23, birthYear: 1995, gender: .female),
    TempUser(userID: "user12@gmail.com", staticIndex: 87, birthYear: 2002, gender: .male),
    TempUser(userID: "user13@gmail.com", staticIndex: 86, birthYear: 1996, gender: .male),
    TempUser(userID: "user14@gmail.com", staticIndex: 54, birthYear: 1997, gender: .female),
    TempUser(userID: "user15@gmail.com", staticIndex: 23, birthYear: 1827, gender: .male),
    TempUser(userID: "user200@gmail.com", staticIndex: 53, birthYear: 1879, gender: .female),
    TempUser(userID: "user3000@gmail.com", staticIndex: 31, birthYear: 1867, gender: .male),
    TempUser(userID: "user40000@gmail.com", staticIndex: 100, birthYear: 1995, gender: .female),
    TempUser(userID: "user567890@gmail.com", staticIndex: 87, birthYear: 2003, gender: .male),
    TempUser(userID: "user654321@gmail.com", staticIndex: 86, birthYear: 1994, gender: .male),
    TempUser(userID: "user79797979@gmail.com", staticIndex: 54, birthYear: 1993, gender: .female),
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
