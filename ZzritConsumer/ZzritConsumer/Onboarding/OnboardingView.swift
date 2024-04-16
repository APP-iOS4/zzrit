//
//  OnboardingView.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/16/24.
//

import SwiftUI

struct OnboardingView: View {
    
    @State private var isShowingMain: Bool = false
    
    // FIXME: 데이터 구조는 추후 리팩토링
    
    private let title: [String] = [
        "당신 주변의\n빠른 모임을 찾아보세요.",
        "모든 모임은\n24시간 동안만 지속됩니다.",
        "주변의 마음에 드는 모임을\n찾으러 가볼까요?"
    ]
    
    private let image: [String] = [
        "Onboarding1", "Onboarding2", "Onboarding3"
    ]
    
    private var isLastPage: Bool {
        return selectedIndex == title.count - 1
    }
    
    private var lastPage: Int {
        return title.count - 1
    }
    
    @State private var selectedIndex: Int = 0
    
    var body: some View {
        ZStack {
            VStack {
                Text(title[selectedIndex])
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .padding(.top, Configs.paddingValue + 50)
                
                Spacer()
                
                Image(image[selectedIndex])
                PageControl(numberOfPages: 3, currentPage: $selectedIndex)
                
                Spacer()
                Spacer()
            }
            .animation(.easeIn, value: selectedIndex)
            
            TabView(selection: $selectedIndex) {
                ForEach(0..<3, id: \.self) { _ in
                    Text("")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .tabViewStyle(.page)
            
            VStack {
                HStack {
                    Spacer()
                    
                    if !isLastPage {
                        Button("건너뛰기") {
                            selectedIndex = lastPage
                        }
                        .foregroundStyle(Color.staticGray3)
                    }
                }
                
                Spacer()
                
                GeneralButton("찾으러가기", isDisabled: !isLastPage) {
                    isShowingMain.toggle()
                }
            }
            .padding(Configs.paddingValue)
        }
        .fullScreenCover(isPresented: $isShowingMain) {
            MainView()
        }
    }
}

#Preview {
    OnboardingView()
}
