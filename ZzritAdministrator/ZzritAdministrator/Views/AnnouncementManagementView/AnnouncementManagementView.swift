//
//  announcementManagement.swift
//  ZzritAdministrator
//
//  Created by Healthy on 4/8/24.
//

import SwiftUI
import ZzritKit

struct AnnouncementManagementView: View {
    
    // 데이트 포매터
    private var dateService = DateService.shared
    
    // TODO: 더미 데이터(삭제 예정)
    @State private var dummyAnnounce = DummyAnnouncement.data
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack(spacing: 20) {
                SearchField(placeHolder: "공지 제목을 입력하세요", action: {
                    print("검색")
                })
                
                RoundedRectangle(cornerRadius: Constants.commonRadius)
                    .foregroundStyle(Color.pointColor)
                    .frame(width: 100, height: 50)
                    .overlay(
                        Button {
                            
                        } label: {
                            Text("등록")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        }
                    )
            }
            
            HStack(spacing: 20) {
                ScrollView {
                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                        Section(header: AnnouncementHeader()) {
                            ForEach(dummyAnnounce) { announce in
                                
                                Button {
                                    
                                } label: {
                                    HStack {
                                        Text(announce.title)
                                        
                                        Spacer()
                                        Divider()
                                        
                                        Text(dateService.formattedString(date: announce.date, format: "yyyy MM/dd HH:mm"))
                                            .frame(width: 150, alignment: .center)
                                    }
                                    .foregroundStyle(Color.black)
                                }
                                .padding(10)
                            }
                        }
                    }
                }
                .overlay {
                    RoundedRectangle(cornerRadius: Constants.commonRadius)
                        .stroke(Color.staticGray3, lineWidth: 1.0)
                }
            }
            Spacer()
        }
        .padding(20)
    }
}

#Preview {
    AnnouncementManagementView()
}

// TODO: 더미 데이터(삭제 예정)
struct DummyAnnouncement {
    static let data: [NoticeModel] = [
        NoticeModel(title: "공지 1입니다 아~ 스태틱 출시 출시", content: "공지 내용입니다 스태틱이 출시되었다고 합니다 모듣들 다운받아서 너 내돋돋도돋ㄷ도도도도내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도 ㅍ내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도", date: Date()),
        
        NoticeModel(title: "공지 1입니다 아~ 스태틱 출시 출시", content: "공지 내용입니다 스태틱이 출시되었다고 합니다 모듣들 다운받아서 너 내돋돋도돋ㄷ도도도도내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도 ㅍ내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도", date: Date()),
        
        NoticeModel(title: "공지 1입니다 아~ 스태틱 출시 출시", content: "공지 내용입니다 스태틱이 출시되었다고 합니다 모듣들 다운받아서 너 내돋돋도돋ㄷ도도도도내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도 ㅍ내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도", date: Date()),
        
        NoticeModel(title: "공지 1입니다 아~ 스태틱 출시 출시", content: "공지 내용입니다 스태틱이 출시되었다고 합니다 모듣들 다운받아서 너 내돋돋도돋ㄷ도도도도내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도 ㅍ내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도", date: Date()),
        
        NoticeModel(title: "공지 1입니다 아~ 스태틱 출시 출시", content: "공지 내용입니다 스태틱이 출시되었다고 합니다 모듣들 다운받아서 너 내돋돋도돋ㄷ도도도도내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도 ㅍ내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도", date: Date()),
        
        NoticeModel(title: "공지 1입니다 아~ 스태틱 출시 출시", content: "공지 내용입니다 스태틱이 출시되었다고 합니다 모듣들 다운받아서 너 내돋돋도돋ㄷ도도도도내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도 ㅍ내돋돋도돋ㄷ도도도도 내돋돋도돋ㄷ도도도도", date: Date()),
    ]
}
