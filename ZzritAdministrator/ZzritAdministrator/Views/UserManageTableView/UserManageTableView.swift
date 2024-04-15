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
    
    @State private var selection: UserModel? = nil
    @State private var isFilterActive: Bool = true
    @State private var isUserModal: Bool = false
    @State private var genderSelection: GenderType? = nil
    @State private var isSortedByStatic: Bool = false
    @State private var isSortedByYear: Bool = false
    @State private var searchText: String = ""
    
    @State private var userData: [UserModel] = tempUsers
    
    var body: some View {
        VStack {
            HStack(spacing: 20.0) {
                SearchField(placeHolder: "유저 이메일을 입력하세요.", text: searchText, action: {
                    print("검색")
                    #if canImport(UIKit)
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    #endif
                })
                Button {
                    print("필터 버튼 눌림")
                    isFilterActive.toggle()
                    isSortedByStatic = false
                    isSortedByYear = false
                    genderSelection = nil
                    userData = tempUsers
                } label: {
                    StaticTextView(title: "필터", selectType: .filter, width: 140.0, isActive: $isFilterActive)
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            
            if isFilterActive {
                HStack {
                    Button {
                        userData = userData.sorted{ $0.staticGuage > $1.staticGuage }
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
                // .padding()
            }

            ScrollView {
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    Section(header: UserSectionHeader())
                    {
                        ForEach(userData) { user in
                            
                            Button {
                                selection = user
                            } label: {
                                HStack {
                                    Text("\(user.userID)")
                                        .minimumScaleFactor(0.5)
                                        .frame(minWidth: 200, alignment: .leading)
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                    
                                    Divider()
                                    
                                    Text("\(String(format: "%.1f", user.staticGuage))W")
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
                                .foregroundStyle(user.id == selection?.id ? Color.pointColor : Color.primary)
                                .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                            }
                            
                        }
                    }
                }
                .onChange(of: genderSelection) { _ in
                    selection = nil
                    
                    guard let genderSelection else {
                        userData = tempUsers
                        return
                    }
                    userData = tempUsers.filter{ $0.gender == genderSelection }
                    
                    if isSortedByStatic {
                        userData = userData.sorted{ $0.staticGuage > $1.staticGuage }
                    } else if isSortedByYear {
                        userData = userData.sorted{ $0.birthYear < $1.birthYear }
                    }
                }
            }
            .listStyle(.plain)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            .overlay {
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                    .stroke(Color.staticGray3, lineWidth: 1.0)
            }
            .padding(.vertical, 5)
            
            HStack {
                MyButton(named: "선택한 유저 제재/관리", features: {
                    if selection != nil {
                        // print("\(selection ?? UUID())")
                        isUserModal.toggle()
                    }
                })
                .frame(maxWidth: .infinity, alignment: .bottomTrailing)
            }
        }
        .padding(20.0)
        .tint(.pointColor)
        .fullScreenCover(isPresented: $isUserModal) {
            UserInfoModalView(isUserModal: $isUserModal, user: selection ?? .init(userID: "example@example.com", userName: "EXAMPLE DATA", userImage: "xmark", gender: .male, birthYear: 1900, staticGuage: 0, agreeServiceDate: Date(), agreePrivacyDate: Date(), agreeLocationDate: Date()))
        }
        .onTapGesture {
            #if canImport(UIKit)
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            #endif
        }
        // .padding()
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
                .frame(minWidth: 300.0, maxWidth: .infinity)
                .frame(height: 50.0)
                .background(Color.pointColor)
                .clipShape(.rect(cornerRadius: Constants.commonRadius))
        }
    }
}

private var tempUsers: [UserModel] = [
    .init(id: UUID().uuidString, userID: "user1@example.com", userName: "A380", userImage: "person", gender: .male, birthYear: 2005, staticGuage: 99, agreeServiceDate: Date(), agreePrivacyDate: Date(), agreeLocationDate: Date()),
    .init(id: UUID().uuidString, userID: "user2@example.com", userName: "A350", userImage: "person", gender: .male, birthYear: 2010, staticGuage: 88, agreeServiceDate: Date(), agreePrivacyDate: Date(), agreeLocationDate: Date()),
    .init(id: UUID().uuidString, userID: "user3@example.com", userName: "A340", userImage: "person", gender: .female, birthYear: 1991, staticGuage: 66, agreeServiceDate: Date(), agreePrivacyDate: Date(), agreeLocationDate: Date()),
    .init(id: UUID().uuidString, userID: "user4@example.com", userName: "A330", userImage: "person", gender: .male, birthYear: 1992, staticGuage: 77, agreeServiceDate: Date(), agreePrivacyDate: Date(), agreeLocationDate: Date()),
    .init(id: UUID().uuidString, userID: "user5@example.com", userName: "A320", userImage: "person", gender: .female, birthYear: 1986, staticGuage: 75, agreeServiceDate: Date(), agreePrivacyDate: Date(), agreeLocationDate: Date()),
    .init(id: UUID().uuidString, userID: "user6@example.com", userName: "A300", userImage: "person", gender: .male, birthYear: 1970, staticGuage: 65, agreeServiceDate: Date(), agreePrivacyDate: Date(), agreeLocationDate: Date()),
    .init(id: UUID().uuidString, userID: "user7@example.com", userName: "A380", userImage: "person", gender: .male, birthYear: 2004, staticGuage: 98, agreeServiceDate: Date(), agreePrivacyDate: Date(), agreeLocationDate: Date()),
    .init(id: UUID().uuidString, userID: "user8@example.com", userName: "A350", userImage: "person", gender: .male, birthYear: 2009, staticGuage: 87, agreeServiceDate: Date(), agreePrivacyDate: Date(), agreeLocationDate: Date()),
    .init(id: UUID().uuidString, userID: "user9@example.com", userName: "A340", userImage: "person", gender: .female, birthYear: 1989, staticGuage: 67, agreeServiceDate: Date(), agreePrivacyDate: Date(), agreeLocationDate: Date()),
    .init(id: UUID().uuidString, userID: "user10@example.com", userName: "A330", userImage: "person", gender: .male, birthYear: 1990, staticGuage: 76, agreeServiceDate: Date(), agreePrivacyDate: Date(), agreeLocationDate: Date()),
    .init(id: UUID().uuidString, userID: "user11@example.com", userName: "A320", userImage: "person", gender: .female, birthYear: 1985, staticGuage: 73, agreeServiceDate: Date(), agreePrivacyDate: Date(), agreeLocationDate: Date()),
    .init(id: UUID().uuidString, userID: "user12@example.com", userName: "A300", userImage: "person", gender: .male, birthYear: 1971, staticGuage: 60, agreeServiceDate: Date(), agreePrivacyDate: Date(), agreeLocationDate: Date()),
    .init(id: UUID().uuidString, userID: "supercalifragilisticexpialidocious@example.com", userName: "Supercalifragilisticexpialidocious", userImage: "person", gender: .male, birthYear: 1971, staticGuage: 30, agreeServiceDate: Date(), agreePrivacyDate: Date(), agreeLocationDate: Date()),
    .init(id: UUID().uuidString, userID: "taumata­whakatangihanga­koauau­o­tamatea­turi­pukaka­piki­maunga­horo­nuku­pokai­whenua­ki­tana­tahu@example.com", userName: "다람쥐 헌 쳇바퀴에 타고파", userImage: "person", gender: .male, birthYear: 1971, staticGuage: 40, agreeServiceDate: Date(), agreePrivacyDate: Date(), agreeLocationDate: Date()),
    .init(id: UUID().uuidString, userID: "krungthepmahanakhonamonrattanakosinmahintharayutthayamahadilokphopnoppharatratchathaniburiromudomratchaniwetmahasathanamonphimanawatansathitsakkathattiyawitsanukamprasit@example.com", userName: "끄룽 텝 마하나콘 아몬 라따나꼬신 마힌타라 유타야 마하딜록 폽 노파랏 랏차타니 부리롬 우돔랏차니웻 마하사탄 아몬 피만 아와딴 사팃 사카타띠야 윗사누깜 쁘라싯", userImage: "person", gender: .male, birthYear: 1971, staticGuage: 35, agreeServiceDate: Date(), agreePrivacyDate: Date(), agreeLocationDate: Date()),
]

#Preview {
    UserManageTableView()
}
