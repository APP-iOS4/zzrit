//
//  RCProcedurePicker.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/10/24.
//

import SwiftUI

import ZzritKit

struct RCProcedurePicker: View {
    @Binding var processSelection: RoomProcessType?
    @Binding var platformSelection: PlatformType?
    @Binding var offlineLocation: OfflineLocationModel?
    
    let onPressButton: () -> Void
    
    @State private var isShowingLocationSearchView: Bool = false
    
    var body: some View {
        VStack(spacing: 10.0) {
            RCSubTitle("진행방식")
            HStack(spacing: 10.0) {
                // 대면(오프라인) 버튼
                SelectionButton(
                    RoomProcessType.offline.rawValue,
                    data: RoomProcessType.offline,
                    selection: $processSelection
                ) {
                    onPressButton()
                }
                // 비대면(온라인) 버튼
                SelectionButton (
                    RoomProcessType.online.rawValue,
                    data: RoomProcessType.online,
                    selection: $processSelection
                ) {
                    onPressButton()
                }
            }
        }
        .padding(.bottom, Configs.paddingValue)
        .lineLimit(3)
        .sheet(isPresented: $isShowingLocationSearchView) {
            OfflineLocationSearchView(offlineLocation: $offlineLocation)
                .presentationDragIndicator(.visible)
        }
        
        if let processSelection {
            DetailView(processType: processSelection)
        }
    }
    
    @ViewBuilder
    func DetailView(processType: RoomProcessType) -> some View {
        // 그리드 열 상수 -> 두 줄
        let columns: [GridItem] = [
            GridItem(.flexible()), GridItem(.flexible())
        ]
        
        switch processType {
        case .online:
            // 온라인 플랫폼 제목
            RCSubTitle("온라인 플랫폼")
            // 온라인 플랫폼 선택 버튼 그리드
            LazyVGrid(columns: columns) {
                ForEach(PlatformType.allCases, id: \.self) { platform in
                    SelectionButton(
                        platform.rawValue,
                        data: platform,
                        selection: $platformSelection,
                        padding: 5.0
                    ) {
                        onPressButton()
                    }
                    .lineLimit(1)
                }
            }
            .padding(.bottom, Configs.paddingValue)
            
        case .offline:
            // 오프라인 위치 제목
            RCSubTitle("위치")
            
            // 위치 버튼
            Button {
                // TODO: 위치 찾는 화면 띄우기

                isShowingLocationSearchView.toggle()
                
            } label: {
                // TODO: 위치에 따라 설명 텍스트 변경
                
                VStack(alignment: .leading, spacing: 10.0) {
                    // 한 줄
                    HStack {
                        Text(offlineLocation?.placeName ?? "주소를 검색하세요.")
                        Spacer()
                        Button {
                            
                        } label: {
                            Image(systemName: "magnifyingglass")
                        }
                    }
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                    
                    if let address = offlineLocation?.address {
                        Text(address)
                            .foregroundStyle(Color.staticGray2)
                    }
                }
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: Configs.cornerRadius)
                        .strokeBorder(Color.staticGray5, lineWidth: 1.0)
                }
            }
            .padding(.bottom, Configs.paddingValue)
        }
    }
}

#Preview {
    RCProcedurePicker(processSelection: .constant(.offline), platformSelection: .constant(.discord), offlineLocation: .constant(nil)) {
        
    }
}
