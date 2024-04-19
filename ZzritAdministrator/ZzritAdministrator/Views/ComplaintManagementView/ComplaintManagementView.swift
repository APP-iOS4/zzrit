//
//  ComplaintManagementView.swift
//  ZzritAdministrator
//
//  Created by Healthy on 4/8/24.
//

// TODO: Complaint가 들어간 기존 뷰 파일 및 구조체 이름 모델에 맞추어 Contact로 변경 필요

import SwiftUI

import ZzritKit

struct ComplaintManagementView: View {
    @EnvironmentObject private var contactViewModel: ContactViewModel
    
    @State private var contactSearchCategory: ContactSearchCategory = .all
    @State private var contactSearchText: String = ""
    @State private var pickedContact: ContactModel?
    @State private var isShowingModalView = false
    let dateService = DateService.shared
    
    @State private var prevValue: Double = 0
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                ContactReasonPickerView(selectReason: $contactSearchCategory)
                    .frame(minWidth: 130, alignment: .leading)
                TextField("문의 제목이나 내용을 입력해주세요.", text: $contactSearchText)
                    .padding(10.0)
                    .padding(.leading)
                Button {
                    print("검색!")
                } label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.white)
                        .padding()
                        .background(Color.pointColor)
                        .clipShape(UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomTrailing: 10, topTrailing: 10)))
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: Constants.commonRadius)
                    .stroke(Color.staticGray3, lineWidth: 1.0)
                    .foregroundStyle(.gray)
            }
            
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(searchContact(searchCategory: contactSearchCategory, searchText: contactSearchText)){ list in
                        Button {
                            pickedContact = list
                            isShowingModalView.toggle()
                            print("modal .toggle     pickUserId = list.id")
                        } label: {
                            ContactListCell(contactTitle: list.title, contactCategory: list.category, contactDateString: dateService.dateString(date: list.requestedDate))
                        }
                        Divider()
                    }
                    
                    // 목록의 하단으로 내려가면 불러오는 함수 실행 - 소비자앱 코드 참조
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.clear)
                        .onAppear {
                            print("불러오기 함수 실행")
                            contactViewModel.loadContacts()
                        }
                }
                .padding(10)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.staticGray3, lineWidth: 1.0)
            }
            .refreshable {
                contactViewModel.loadContacts()
            }
        }
        .padding(20)
        .fullScreenCover(isPresented: $isShowingModalView) {
            ComplaintDetailView(contact: $pickedContact, isShowingModalView: $isShowingModalView)
        }
    }
    
    func searchContact(searchCategory: ContactSearchCategory, searchText: String) -> [ContactModel] {
        switch searchCategory {
        case .all:
            return contactSearchText.isEmpty ? contactViewModel.contacts : contactViewModel.contacts.filter {
                $0.title.contains(searchText) || $0.content.contains(searchText)
            }
        case .app:
            return contactSearchText.isEmpty ? contactViewModel.contacts.filter { $0.category == .app } : contactViewModel.contacts.filter {
                $0.category == .app && ( $0.title.contains(searchText) || $0.content.contains(searchText))
            }
        case .room:
            return contactSearchText.isEmpty ? contactViewModel.contacts.filter { $0.category == .room } : contactViewModel.contacts.filter {
                $0.category == .room && ( $0.title.contains(searchText) || $0.content.contains(searchText))
            }
        }
    }
}

struct ContactReasonPickerView: View {
    @Binding var selectReason: ContactSearchCategory
    var body: some View {
        Picker("\(selectReason)", selection: $selectReason){
            Text("전체").tag(ContactSearchCategory.all)
            Text("앱 이용 문의").tag(ContactSearchCategory.app)
            Text("모임 신고").tag(ContactSearchCategory.room)
        }
        .pickerStyle(.menu)
        .tint(Color.pointColor)
    }
}

struct ContactListCell: View {
    var contactTitle: String
    var contactCategory: ContactCategory
    var contactDateString: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("\(contactTitle)")
                    .foregroundStyle(Color.primary)
                    .fontWeight(.bold)
                HStack {
                    Text("\(contactCategory.rawValue)")
                        .fontWeight(.bold)
                        .foregroundStyle(Color.pointColor)
                    Text("\(contactDateString)")
                        .foregroundStyle(Color.staticGray2)
                }
            }
            
            Spacer()
        }
        .padding(10)
    }
}

enum ContactSearchCategory: String {
    case all = "전체"
    case app = "앱 이용 문의"
    case room = "모임 신고"
}


#Preview {
    ComplaintManagementView()
        .environmentObject(ContactViewModel())
}
