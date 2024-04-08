//
//  UserInfoModalView.swift
//  ZzritAdministrator
//
//  Created by 이우석 on 4/8/24.
//

import SwiftUI

struct UserInfoModalView: View {
    @Binding var isUserModal: Bool
    var user: TempUser
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                HStack(spacing: 30) {
                    InfoLabelView(title: "이메일", contents: "\(user.userID)")
                    InfoLabelView(title: "출생년도", contents: "\(user.birthYear)")
                    InfoLabelView(title: "성별", contents: "\(user.gender.rawValue)")
                    Spacer()
                    Text("관리자지정")
                        .foregroundStyle(Color.staticGray3)
                }
                .padding(20)
                .overlay {
                    RoundedRectangle(cornerRadius: Constants.commonRadius)
                        .stroke(Color.staticGray3, lineWidth: 1.0)
                }
                StaticTextView(title: "\(user.staticIndex)W", width: 100, isActive: .constant(true))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            HStack {
                Text("제재 이력")
                Spacer()
                HStack {
                    Text("계정 상태 : ")
                    Text("정상")
                        .fontWeight(.bold)
                        .foregroundStyle(Color.pointColor)
                }
            }
            BanList()
                .overlay {
                    RoundedRectangle(cornerRadius: Constants.commonRadius)
                        .stroke(Color.staticGray3, lineWidth: 1.0)
                }
            Spacer(minLength: 100)
            HStack(spacing: 20) {
                Button {
                    isUserModal.toggle()
                }label: {
                    StaticTextView(title: "취소", isActive: .constant(false))
                }
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .frame(width: 100)
                
                banReasonField(user: user)
            }
        }
        .tint(.pointColor)
        .padding(20)
        .onTapGesture {
            #if canImport(UIKit)
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            #endif
        }
    }
}

struct InfoLabelView: View {
    var title: String
    var contents: String
    var body: some View {
        HStack {
            Text("\(title) : ")
                .fontWeight(.bold)
                .foregroundStyle(Color.pointColor)
            Text("\(contents)")
        }
    }
}

struct BanList: View {
    var body: some View {
        ScrollView {
            ForEach(SomeoneBanList) { list in
                BanListCell(banDate: list.banDate, banPeriod: list.banPeriod, banReason: list.banReason, banManagerMemo: list.banManagerMemo)
            }
            .padding(20)
        }
    }
}

struct BanListCell: View {
    var banDate: String
    var banPeriod: Int
    var banReason: String
    var banManagerMemo: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("\(banDate)")
                    .fontWeight(.bold)
                HStack(spacing: 20) {
                    Text("\(banPeriod)일")
                        .fontWeight(.bold)
                        .foregroundStyle(Color.pointColor)
                    Text("\(banReason)")
                    Text("\(banManagerMemo)")
                        .foregroundStyle(Color.staticGray3)
                }
            }
            Spacer()
        }
        Divider()
    }
}

struct banReasonField: View {
    var user: TempUser
    @State private var banReason: BannedType = .abuse
    @State private var banPeriod = 3
    @State private var banMemo = ""
    @State private var banAlert = false
    @State var isButtonActive: Bool = false
    
    var body: some View {
        HStack {
            banReasonPickerView(selectReason: $banReason)
            banPeriodPickerView(banPeriod: $banPeriod)
            TextField("제재 사유를 입력해주세요.", text: $banMemo)
                .padding(10.0)
                .padding(.leading)
            Button {
                if !banMemo.isEmpty{
                    banAlert.toggle()
                }
            } label: {
                Text("제재등록")
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.pointColor)
                    .clipShape(UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomTrailing: 10, topTrailing: 10)))
            }
        }
        .background {
            RoundedRectangle(cornerRadius: Constants.commonRadius)
                .foregroundStyle(.white)
                .shadow(radius: 10)
        }
        .alert("제재하시겠습니까?", isPresented: $banAlert) {
            Button("취소하기", role: .cancel){
                print("취소하기")
                banAlert.toggle()
            }
            Button("제재하기", role: .destructive){
                print("제재하기")
                banAlert.toggle()
            }
        } message: {
            Text("\"\(String(describing: user.userID))\"를 \(banReason.rawValue)(으)로 \(banPeriod)일 제재\n사유 : \(banMemo)")
        }
        
    }
}

struct banReasonPickerView: View {
    @Binding var selectReason: BannedType
    var body: some View {
        Picker("\(selectReason)", selection: $selectReason){
            Text("폭언/욕설 사용").tag(BannedType.abuse)
            Text("부적절한 모임 개설").tag(BannedType.wrongRoom)
            Text("종교 권유").tag(BannedType.religin)
            Text("불법 도박 홍보").tag(BannedType.gambling)
            Text("음란성 모임 개설").tag(BannedType.obscenity)
            Text("기타 사유").tag(BannedType.administrator)
        }
        .pickerStyle(.menu)
        .foregroundStyle(Color.accentColor)
    }
}

struct banPeriodPickerView: View {
    @Binding var banPeriod: Int
    var body: some View {
        Picker("\(banPeriod)일", selection: $banPeriod){
            Text("3일").tag(3)
            Text("5일").tag(5)
            Text("7일").tag(7)
            Text("14일").tag(14)
            Text("30일").tag(30)
            Text("180일").tag(180)
            Text("1년").tag(365)
            Text("영구").tag(3649635)
        }
        .pickerStyle(.menu)
        .foregroundStyle(Color.accentColor)
    }
}

struct SomeoneBan: Identifiable {
    var id: UUID = UUID()
    
    let banDate: String
    let banPeriod: Int
    let banReason: String   //enum 예정
    let banManagerMemo: String
}

private var SomeoneBanList: [SomeoneBan] = [
    SomeoneBan(banDate: "2023-09-21", banPeriod: 3, banReason: "욕설 사용으로 인한 정지", banManagerMemo: "채팅 내용 중 욕설 사용 확인"),
    SomeoneBan(banDate: "2023-09-21", banPeriod: 3, banReason: "욕설 사용으로 인한 정지", banManagerMemo: "채팅 내용 중 욕설 사용 확인"),
    SomeoneBan(banDate: "2023-09-21", banPeriod: 3, banReason: "욕설 사용으로 인한 정지", banManagerMemo: "채팅 내용 중 욕설 사용 확인"),
    SomeoneBan(banDate: "2023-09-21", banPeriod: 3, banReason: "욕설 사용으로 인한 정지", banManagerMemo: "채팅 내용 중 욕설 사용 확인"),
    SomeoneBan(banDate: "2023-09-21", banPeriod: 3, banReason: "욕설 사용으로 인한 정지", banManagerMemo: "채팅 내용 중 욕설 사용 확인")
]

// MARK: 이 부분은 임시
// TODO: ZzritKit으로 옮길 예정
enum BannedType: String, CaseIterable, Codable {
    case abuse = "폭언/욕설 사용"
    case wrongRoom = "부적절한 모임 개설"
    case religin = "종교 권유"
    case gambling = "불법 도박 홍보"
    case obscenity = "음란성 모임 개설"
    case administrator = "기타 사유"
}

#Preview {
    UserInfoModalView(isUserModal: .constant(true), user: .init(userID: "example", staticIndex: 100, birthYear: 1900, gender: .male))
}
