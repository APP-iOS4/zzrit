//
//  RCProcedurePicker.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/10/24.
//

import SwiftUI

import ZzritKit

struct RCProcedurePicker: View {
    @Binding var isOnline: Bool?
    @Binding var platformSelection: PlatformType?
    let onPressButton: () -> Void
    
    var body: some View {
        VStack {
            RoomCreateSubTitle("진행방식")
            HStack(spacing: 10.0) {
                SelectionButtonView(
                    title: "대면(오프라인)",
                    data: false,
                    selection: $isOnline
                ) {
                    onPressButton()
                }
                
                SelectionButtonView(
                    title: "비대면(온라인)",
                    data: true,
                    selection: $isOnline
                ) {
                    onPressButton()
                }
            }
        }
        .padding(.vertical)
        
        if let isOnline {
            detailView(isOnline: isOnline)
        }
    }
    
    @ViewBuilder
    func detailView(isOnline: Bool) -> some View {
        // 그리드 열 상수 -> 두 줄
        let columns: [GridItem] = [
            GridItem(.flexible()), GridItem(.flexible())
        ]
        
        // 온라인이 선택된 경우
        if isOnline {
            // 온라인 플랫폼 제목
            RoomCreateSubTitle("온라인 플랫폼")
            
            // 온라인 플랫폼 선택 버튼 그리드
            LazyVGrid(columns: columns) {
                ForEach(PlatformType.allCases, id: \.self) { platform in
                    SelectionButtonView(
                        title: platform.rawValue,
                        data: platform,
                        selection: $platformSelection,
                        padding: 5.0
                    ) {
                        onPressButton()
                    }
                    .lineLimit(1)
                }
            }
        } else {
            // 위치 제목
            RoomCreateSubTitle("위치")
            
            // 위치 버튼
            Button {
                // TODO: 위치 찾는 화면 띄우기
                
                print("위치 찾기 버튼 눌림")
                
            } label: {
                // TODO: 위치에 따라 설명 텍스트 변경
                
                VStack(alignment: .leading, spacing: 10.0) {
                    // 한 줄
                    HStack {
                        Text("멋쟁이사자처럼")
                        Spacer()
                        Image(systemName: "magnifyingglass")
                    }
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                    
                    Text("서울 종로구 종로 3길 17 D타워 D1동 16, 17층")
                        .foregroundStyle(Color.staticGray2)
                }
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: Configs.cornerRadius)
                        .stroke(Color.staticGray5, lineWidth: 1.0)
                }
            }
        }
    }
}

#Preview {
    RCProcedurePicker(isOnline: .constant(false), platformSelection: .constant(nil)) {
        
    }
}
