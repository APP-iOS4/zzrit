//
//  BanReasonField.swift
//  ZzritAdministrator
//
//  Created by 이우석 on 4/11/24.
//

import SwiftUI

import ZzritKit

struct BanReasonField: View {
    @EnvironmentObject var userViewModel: UserViewModel
    
    var user: UserModel
    @State private var banReason: BannedType = .abuse
    @State private var banPeriod = 3
    @State private var banMemo = ""
    @State private var banAlert = false
    @State private var isButtonActive: Bool = false
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
                    penalizeUser()
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
        .overlay {
            RoundedRectangle(cornerRadius: Constants.commonRadius)
                .stroke(Color.staticGray3, lineWidth: 1.0)
        }
        .alert("제재하시겠습니까?", isPresented: $banAlert) {
            Button("취소하기", role: .cancel){
                print("취소하기")
                banAlert.toggle()
            }
            Button("제재하기", role: .destructive){
                if let id = user.id {
                    // userViewModel.startRestriction(userID: id, type: banReason, period: banPeriod, content: banMemo)
                }
                
                print("제재하기")
                banAlert.toggle()
                // isUserModal.toggle()
            }
        } message: {
            Text("\"\(String(describing: user.userID))\"를 \(banReason.rawValue)(으)로 \(banPeriod)일 제재\n제재 후 정전기 지수: \(String(format: "%.1f", indexAfterPenalty))W \n사유 : \(banMemo)")
        }
        
    }
    
    private func penalizeUser() {
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
        case 730000:
            100
        default:
            0
        }
        
        indexAfterPenalty = if user.staticGauge - penalty < 0 {
            0
        } else {
            user.staticGauge - penalty
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
            Text("영구 (-100W)").tag(730000)
        }
        .pickerStyle(.menu)
        .foregroundStyle(Color.accentColor)
    }
}
