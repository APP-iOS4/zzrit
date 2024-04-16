//
//  PlaygroundManageMainView.swift
//  ZzritAdministrator
//
//  Created by Healthy on 4/8/24.
//

import SwiftUI
import ZzritKit

struct RoomManageView: View {
    // 모임 뷰모델
    @EnvironmentObject private var roomViewModel: RoomViewModel
    
    // 선택된 모임
    @State private var selectedRoom: RoomModel? = nil
    
    @State private var showRoomDetail: Bool = false
    
    // 데이트 서비스
    private var dateService = DateService.shared
    
    // TODO: 뷰 뷴리는 로그인 뷰부터 짜고(급해서) 진행하겠습니다
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            SearchField(action: {
                print("검색")
            })
            
            HStack(spacing: 20) {
                ScrollView {
                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                        Section(header: RoomSectionHeader()) {
                            ForEach(roomViewModel.rooms) { room in
                                Button {
                                    selectedRoom = room
                                } label: {
                                    HStack {
                                        Text(room.title)
                                            .frame(minWidth: 100, alignment: .leading)
                                            .multilineTextAlignment(.leading)
                                        Spacer()
                                        
                                        Divider()
                                        
                                        Text("\(room.limitPeople)")
                                            .frame(width: 90, alignment: .leading)
                                        
                                        Divider()
                                        
                                        Text(dateService.formattedString(date: room.dateTime, format: "MM/dd HH:mm"))
                                            .frame(width: 120, alignment: .leading)
                                            .multilineTextAlignment(.leading)
                                        
                                        Divider()
                                        
                                        Text(room.status == ActiveType.activation ? "활성화" : "비활성화")
                                            .frame(width: 90, alignment: .leading)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .font(.title3)
                                    .foregroundStyle(room.id == selectedRoom?.id ? Color.pointColor : Color.primary)
                                    .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                                }
                            }
                            
                            Button {
                                
                            } label: {
                                Text("")
                            }
                            .onAppear {
                                roomViewModel.loadRooms()
                            }
                        }
                    }
                }
                .overlay {
                    RoundedRectangle(cornerRadius: Constants.commonRadius)
                        .stroke(Color.staticGray3, lineWidth: 1.0)
                }
            }
            
            MyButton(named: "선택한 모임 관리") {
                if selectedRoom != nil {
                    showRoomDetail.toggle()
                }
            }
           .frame(maxWidth: .infinity, alignment: .bottomTrailing)
        }
        .padding(20)
        .fullScreenCover(isPresented: $showRoomDetail, content: {
            // 버튼 단계에서 nil일 시 동작하지 않도록 에러처리를 했기 때문에 포스 언래핑
            RoomDetailView(room: selectedRoom!)
        })
    }
    
//    // TODO: 로직 수정해야 함
//    /// 모임 비활성화 얼럿
//    func getInactiveAlert() -> Alert {
//        return Alert(
//            title: Text("모임 비활성화"),
//            message: Text("정말 모임을 비활성화 하시겠습니까?"),
//            primaryButton: .destructive(Text("비활성화"), action: {
//                istActive = false
//            }),
//            secondaryButton: .cancel(Text("취소")))
//    }
//    
//    /// 모임 활성화 얼럿
//    func getActiveAlert() -> Alert {
//        return Alert(
//            title: Text("모임 활성화"),
//            message: Text("정말 모임을 활성화 하시겠습니까?"),
//            primaryButton: .destructive(Text("활성화"), action: {
//                istActive = true
//            }),
//            secondaryButton: .cancel(Text("취소")))
//    }
}

#Preview {
    RoomManageView()
        .environmentObject(RoomViewModel())
}
