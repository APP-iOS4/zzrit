//
//  UserInfoModalView.swift
//  ZzritAdministrator
//
//  Created by 이우석 on 4/8/24.
//

import SwiftUI

import ZzritKit

struct UserInfoModalView: View {
    @Binding var isUserModal: Bool
    var user: UserModel
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    InfoLabelView(title: "이메일", contents: "\(user.userID)")
                    
                    HStack(spacing: 30){
                        InfoLabelView(title: "출생년도", contents: "\(user.birthYear)")
                        InfoLabelView(title: "성별", contents: "\(user.gender.rawValue)")
                        
                        Spacer()
                        
                        Text("관리자지정")
                            .foregroundStyle(Color.staticGray3)
                    }
                }
                .padding(20)
                .overlay {
                    RoundedRectangle(cornerRadius: Constants.commonRadius)
                        .stroke(Color.staticGray3, lineWidth: 1.0)
                }
                StaticTextView(title: "\(String(format: "%.1f", user.staticGuage))W", width: 100, isActive: .constant(true))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            HStack {
                Text("제재 이력")
                    .fontWeight(.bold)
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
                
                banReasonField(user: user, isUserModal: $isUserModal)
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
    var user: UserModel
    @State private var banReason: BannedType = .abuse
    @State private var banPeriod = 3
    @State private var banMemo = ""
    @State private var banAlert = false
    @State var isButtonActive: Bool = false
    @State private var indexAfterPenalty: Double = 0
    @Binding var isUserModal: Bool
    
    var body: some View {
        HStack {
            banReasonPickerView(selectReason: $banReason)
            banPeriodPickerView(banPeriod: $banPeriod)
            TextField("제재 사유를 입력해주세요.", text: $banMemo)
                .padding(10.0)
                .padding(.leading)
            Button {
                if !banMemo.isEmpty{
                    let penalty: Double = switch banPeriod {
                    case 3:
                        1
                    case 5:
                        2
                    case 7:
                        3
                    case 14:
                        5
                    case 30:
                        10
                    case 180:
                        20
                    case 365:
                        30
                    case 3649635:
                        100
                    default:
                        0
                    }
                    
                    indexAfterPenalty = if user.staticGuage - penalty < 0 {
                        0
                    } else {
                        user.staticGuage - penalty
                    }
                    
                    banAlert.toggle()
                }
            } label: {
                Text("제재 등록")
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
                isUserModal.toggle()
            }
        } message: {
            Text("\"\(String(describing: user.userID))\"를 \(banReason.rawValue)(으)로 \(banPeriod)일 제재\n제재 후 정전기 지수: \(String(format: "%.1f", indexAfterPenalty))W \n사유 : \(banMemo)")
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
            Text("3일 (-1W)").tag(3)
            Text("5일 (-2W)").tag(5)
            Text("7일 (-3W)").tag(7)
            Text("14일 (-5W)").tag(14)
            Text("30일 (-10W)").tag(30)
            Text("180일 (-20W)").tag(180)
            Text("1년 (-30W)").tag(365)
            Text("영구 (-100W)").tag(3649635)
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

#Preview {
    UserInfoModalView(isUserModal: .constant(true), user: .init(userID: "example@example.com", userName: "EXAMPLE DATA", userImage: "xmark", gender: .male, birthYear: 1900, staticGuage: 0))
}
