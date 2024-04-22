//
//  ImagePickerExtensions.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/16/24.
//

import SwiftUI

// View Extensions
extension View {
    /// 커스텀 이미지 피커
    /// - Parameter imageSize: 리턴받을 이미지의 크기(CGSize)
    /// - Parameter show: 파라미터에 대한 설명
    /// - Parameter croppedImage: 파라미터에 대한 설명
    /// - Returns: some View: CustomImagePicker
    @ViewBuilder
    func cropImagePicker(imageSize: CGSize, show: Binding<Bool>, croppedImage: Binding<UIImage?>) -> some View {
        ImagePickerView(imageSize: imageSize, show: show, croppedImage: croppedImage) {
            self
        }
    }
    
    /// 변경된 뷰의 크기의 뷰를 리턴한다.(??)
    @ViewBuilder
    func frame(_ size: CGSize) -> some View {
        self
            .frame(width: size.width, height: size.height)
    }
    
    // 햅틱 피드백
    func haptics(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}
