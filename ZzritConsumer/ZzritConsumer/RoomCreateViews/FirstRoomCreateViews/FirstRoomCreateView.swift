//
//  FirstRoomCreateView.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/9/24.
//

import SwiftUI

struct FirstRoomCreateView: View {
    @Environment(\.dismiss) private var dismiss
    @State var selection: CategoryPickerEnum? = nil
    @State var isOnNextButton: Bool = false
    
    let columns: [GridItem] = [
        GridItem(.flexible()), GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                // 첫 번째 페이지 Indicator
                RoomCreateIndicator(page: .first)
                    .padding()
                    .padding(.bottom, Configs.paddingValue)
                
                // 모임 선택
                RoomCreateSubTitle("모임 주제를 선택해주세요.")
                    .padding()
                
                LazyVGrid(columns: columns, content: {
                    ForEach(CategoryPickerEnum.allCases, id: \.self) { category in
                        CategoryCellView(data: category, selection: $selection) {
                            if selection != nil {
                                isOnNextButton = true
                            }
                        }
                            
                    }
                })
                .padding()
                
                Spacer()
                
                GeneralButton(isDisabled: !isOnNextButton, "다음", tapAction: {
                    
                })
                .padding()
            }
            .navigationTitle("모임개설")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading, content: {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundStyle(.black)
                    }
                })
            }
        }
    }
}

#Preview {
    FirstRoomCreateView()
}
