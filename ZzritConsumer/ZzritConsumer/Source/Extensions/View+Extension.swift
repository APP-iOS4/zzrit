//
//  View+Extension.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/10/24.
//

import SwiftUI

import GoogleMobileAds
import ZzritKit

// 텍스트필드 뷰 클릭 시 비활성화
extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
    
    func roundedBorder(_ width: CGFloat = 1, color: Color = Color.staticGray5, radius: CGFloat = 10) -> some View {
        self
            .padding(.horizontal, 10)
            .padding(.vertical, 15)
            .background {
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .strokeBorder(color, lineWidth: width)
            }
    }
    
    /// 버전 분기를 위한 onChange 단순화
    func customOnChange<T: Equatable>(of target: T, handler: @escaping (T) -> Void) -> AnyView {
        if #available(iOS 17.0, *) {
            return AnyView(
                self
                    .onChange(of: target) { _, newValue in
                        handler(newValue)
                    }
            )
        } else {
            return AnyView(
                self
                    .onChange(of: target) { newValue in
                        handler(newValue)
                    }
            )
        }
    }
    
    /// 화면 전체를 로딩뷰로 감쌉니다.
    @ViewBuilder
    func loading(_ visiable: Bool, message: String? = nil) -> some View {
        if visiable {
            self
                .overlay {
                    if visiable {
                        LoadingView(message: message)
                    }
                }
                .toolbar(.hidden, for: .navigationBar)
                .toolbar(.hidden, for: .tabBar)
                .animation(.easeIn, value: visiable)
        } else {
            self
                .toolbar(.automatic, for: .navigationBar)
                .toolbar(.automatic, for: .tabBar)
        }
    }
    
    /// 구글 애드몹 사이즈 초기화
    func initGADSize() -> some View {
        var bannerWidth: CGFloat {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return 0.0 }
            return windowScene.screen.bounds.width
        }
        
        return self
            .frame(width: bannerWidth, height: GADLandscapeAnchoredAdaptiveBannerAdSizeWithWidth(bannerWidth).size.height)
    }
}
