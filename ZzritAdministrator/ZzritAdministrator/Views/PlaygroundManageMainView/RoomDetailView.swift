//
//  RoomDetailView.swift
//  ZzritAdministrator
//
//  Created by Healthy on 4/16/24.
//

import SwiftUI
import ZzritKit
import CoreLocation

struct RoomDetailView: View {
    // 모임 뷰모델
    @EnvironmentObject private var roomViewModel: RoomViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var room: RoomModel
    @State private var joinedUsers: [JoinedUserModel] = []
    @State private var selectedUserIndex: Int? = nil
    @State private var showActiveAlert: Bool = false
    
    // 데이트 서비스
    var dateService = DateService.shared
    
    var body: some View {
        VStack(spacing: 0) {
            Text(room.title)
                .font(.title3)
                .padding(10.0)
                .padding(.leading)
                .frame(maxWidth: .infinity)
                .overlay {
                    RoundedRectangle(cornerRadius: Constants.commonRadius)
                        .stroke(Color.staticGray3, lineWidth: 1.0)
                }
            
            Spacer()
                .frame(height: 20)
            
            HStack {
                Text("상세 정보")
                    .fontWeight(.bold)
                
                Spacer()
                
                Text("현재 상태: ")
                    .fontWeight(.bold)
                
                Button {
                    if room.status != .delete {
                        showActiveAlert = true
                    }
                } label: {
                    Text(room.status.rawValue)
                        .fontWeight(.bold)
                }
                .buttonStyle(.borderedProminent)
                .tint(room.status == .deactivation || room.status == .delete ? Color.staticGray3 : Color.pointColor)
            }
            .padding(.horizontal, 10)
            
            Spacer()
                .frame(height: 10)

            RoomInfoView(room: room)
            .padding(.bottom, 20)
            
            HStack {
                Text("참여자 정보 (\(joinedUsers.count) / \(room.limitPeople))")
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
            
            JoinedUserInfoView(selectedUserIndex: $selectedUserIndex, joinedUsers: joinedUsers)

            Spacer()
                .frame(height: 20)
            
            HStack {
                MyButton(named: "돌아가기") {
                    dismiss()
                }
                .frame(width: 120)
                
                Spacer()
            }
        }
        .padding(20)
        .onAppear {
            Task {
                await fetchJoinedUser()
            }
        }
        .alert(isPresented: $showActiveAlert) {
            if room.status == .activation {
                getInactiveAlert()
            } else {
                getActiveAlert()
            }
        }
    }
    
    /// 모임에 참여한 유저 데이터 불러오기
    func fetchJoinedUser() async {
        // 모임에는 반드시 ID값이 존재하기 때문에 포스 언래핑
        joinedUsers = await roomViewModel.loadJoinedUsers(roomID: room.id!)
    }
    
    /// 모임 비활성화 얼럿
    func getInactiveAlert() -> Alert {
        return Alert(
            title: Text("모임 비활성화"),
            message: Text("정말 모임을 비활성화 하시겠습니까?"),
            primaryButton: .destructive(Text("비활성화"), action: {
                // 모임의 id는 반드시 존재하기 때문에 포스 언래핑
                roomViewModel.changeStatus(roomID: room.id!, status: .deactivation)
                room.status = .deactivation
            }),
            secondaryButton: .cancel(Text("취소")))
    }
    
    /// 모임 활성화 얼럿
    func getActiveAlert() -> Alert {
        return Alert(
            title: Text("모임 활성화"),
            message: Text("정말 모임을 활성화 하시겠습니까?"),
            primaryButton: .destructive(Text("활성화"), action: {
                // 모임의 id는 반드시 존재하기 때문에 포스 언래핑
                roomViewModel.changeStatus(roomID: room.id!, status: .activation)
                room.status = .activation
            }),
            secondaryButton: .cancel(Text("취소")))
    }
}

#Preview {
    RoomDetailView(room: RoomModel(title: "모임 이름", category: .art, dateTime: Date(), content: "efpokepsofkspeofkpoesfk  pkfdpofkpoekf", coverImage: "efkef", isOnline: true, status: .activation, leaderID: "fepsfkspoek", limitPeople: 11))
       .environmentObject(RoomViewModel())
}

struct RoomInfoView: View {
    @State private var room: RoomModel
    @State private var address: String?
    
    var dateService = DateService.shared
 
    var body: some View {
        List {
            Section {
                Text("\(room.content)")
            } header: {
                Text("소개")
            }
            
            LabeledContent("방장 ID", value: "\(room.leaderID)")
            
            if room.isOnline {
                LabeledContent("플랫폼", value: room.platform?.rawValue ?? "플랫폼 정보없음")
            } else {
                // TODO: 위치 정보 표시 논의하기
                LabeledContent("위치 정보", value: address ?? "위치정보 없음")
            }
            
            LabeledContent("카테고리", value: room.category.rawValue)
            LabeledContent("모임날짜", value: dateService.formattedString(date: room.dateTime, format: "MM/dd - HH:mm"))
            LabeledContent("종료시간", value: dateService.formattedString(date: room.limitTime(), format: "MM/dd - HH:mm"))
            LabeledContent("인원제한", value: "\(room.limitPeople)")
        }
        .listStyle(.inset)
        .listRowSeparator(.hidden)
        .overlay(
            RoundedRectangle(cornerRadius: Constants.commonRadius)
                .stroke(Color.staticGray3, lineWidth: 1.0)
        )
        .onAppear {
            print("주소 로딩 시작")
            if let latitude = room.placeLatitude, let longitude = room.placeLongitude {
                getAddress(latitude: latitude, longitude: longitude)
            } else {
                print("좌표 정보 없음")
            }
        }
    }
    
    func getAddress(latitude: Double, longitude: Double) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)

        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error {
                print(error)
                return
            }
            
            if let placemark = placemarks?.first {
                print("\(String(describing: placemark.locality))\(String(describing: placemark.country))\(String(describing: placemark.thoroughfare))\(String(describing: placemark.subThoroughfare))")
                
                address = "\(String(describing: placemark.locality))\(String(describing: placemark.country))\(String(describing: placemark.thoroughfare))\(String(describing: placemark.subThoroughfare))"
            }
        }
    }
}

struct JoinedUserInfoView: View {
    @Binding var selectedUserIndex: Int?
    
    var joinedUsers: [JoinedUserModel]
    // 데이트 서비스
    var dateService = DateService.shared
    
    var body: some View {
        List {
            ForEach(0 ..< joinedUsers.count, id: \.self) { index in
                Button {
                    selectedUserIndex = index
                } label: {
                    VStack {
                        LabeledContent("유저 ID :", value: joinedUsers[index].userID)
                        LabeledContent("참여한 날짜 :", value: dateService.formattedString(date: joinedUsers[index].joinedDatetime, format: "MM/dd - HH:mm"))
                    }
                    .foregroundStyle(selectedUserIndex == index ? Color.pointColor : Color.staticGray3)
                }
            }
        }
        .listStyle(.inset)
        .overlay (
            RoundedRectangle(cornerRadius: Constants.commonRadius)
                .stroke(Color.staticGray3, lineWidth: 1.0)
        )
    }
}
