//
//  RCCustomNaviBar.swift
//  StaticTemp
//
//  Created by 이선준 on 4/13/24.
//

import SwiftUI

struct RCNavigationBar<Content>: View where Content: View {
//    @EnvironmentObject var coordinator: Coordinator
    @Environment(\.dismiss) var dismiss
    
    let content: () -> Content
    let page: NewRoom
    
    // MARK: - init
    
    init(page: NewRoom, @ViewBuilder content: @escaping () -> Content) {
        self.page = page
        self.content = content
    }
    
    //  MARK: - body
    
    var body: some View {
        // 인디케이터(Indicator)
        HStack {
            ForEach(NewRoom.allCases, id: \.self) { index in
                RoundedRectangle(cornerRadius: Configs.cornerRadius)
                    .fill(index.rawValue <= page.rawValue ? Color.pointColor : Color.staticGray6)
                    .frame(height: 4.0)
            }
        }
        .padding(Configs.paddingValue)
        .toolbar {
            // 메뉴
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.black)
                }
            }
        }
        .navigationTitle(page.description)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarRole(.editor)
        
        // 들어올 내용
        content()
            .padding(Configs.paddingValue)
            .onAppear {
//                coordinator.printPath()
            }
    }
}

#Preview {
    NavigationStack {
        RCNavigationBar(page: .page1) {
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Text("Hello")
                    Spacer()
                }
                Spacer()
            }
        }
//        .environmentObject(Coordinator())
    }
}
