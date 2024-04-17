//
//  UserManageTableView.swift
//  ZzritAdministrator
//
//  Created by Healthy on 4/8/24.
//

import SwiftUI

import ZzritKit

struct UserManageTableView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    
    let genderList: [GenderType] = [.male, .female]
    
    @State private var selection: UserModel? = nil
    @State private var isFilterActive: Bool = true
    @State private var isUserModal: Bool = false
    @State private var genderSelection: GenderType? = nil
    @State private var isSortedByStatic: Bool = false
    @State private var isSortedByYear: Bool = false
    @State private var searchText: String = ""
    
    @State private var userData: [UserModel] = []
    
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
                    userData = userViewModel.users
                } label: {
                    StaticTextView(title: "필터", selectType: .filter, width: 140.0, isActive: $isFilterActive)
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            
            if isFilterActive {
                HStack {
                    Button {
                        userData = userData.sorted{ $0.staticGauge > $1.staticGauge }
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
                                    
                                    Text("\(String(format: "%.1f", user.staticGauge))W")
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
                        userData = userViewModel.users
                        return
                    }
                    userData = userViewModel.users.filter{ $0.gender == genderSelection }
                    
                    if isSortedByStatic {
                        userData = userViewModel.users.sorted{ $0.staticGauge > $1.staticGauge }
                    } else if isSortedByYear {
                        userData = userViewModel.users.sorted{ $0.birthYear < $1.birthYear }
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
            .refreshable {
                userViewModel.loadUsers()
                userData = userViewModel.users
            }
            
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
            UserInfoModalView(isUserModal: $isUserModal, user: selection ?? .init(userID: "example@example.com", userName: "EXAMPLE DATA", userImage: "xmark", gender: .male, birthYear: 1900, staticGauge: 0, agreeServiceDate: Date(), agreePrivacyDate: Date(), agreeLocationDate: Date()))
        }
        .onChange(of: isUserModal) { _ in
            DispatchQueue.main.async {
                userData = userViewModel.users
                
                if let selectedUser = selection {
                    if let index = userData.firstIndex(where: { $0.id == selectedUser.id }) {
                        selection = userData[index]
                    }
                }
            }
        }
        .onAppear {
            userData = userViewModel.users
        }
        .onTapGesture {
            #if canImport(UIKit)
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            #endif
        }
        // .padding()
    }
}

#Preview {
    UserManageTableView()
}
