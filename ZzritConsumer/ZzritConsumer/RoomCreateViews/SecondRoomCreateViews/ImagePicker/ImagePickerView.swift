//
//  ImagePickerView.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/16/24.
//

import SwiftUI

import SwiftUI
import PhotosUI

/// 커스텀 이미지 피커
/// - Parameter options: 파라미터에 대한 설명
/// - Parameter show: 이미지 피커를 화면에 띄울 것인지에 대한 Bool 타입 값
/// - Parameter croppedImage: 결과로 리턴될 이미지와 연결할 변수
struct ImagePickerView<Content: View>: View {
    var content: Content
    // 저장될 이미지의 크기
    var imageSize: CGSize
    
    /// 이미지 피커를 화면에 띄울 것인지에 대한 Bool 타입 값
    @Binding var show: Bool
    /// 결과로 리턴될 이미지와 연결된 변수
    @Binding var croppedImage: UIImage?
    
    init(imageSize: CGSize, show: Binding<Bool>, croppedImage: Binding<UIImage?>, @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self._show = show
        self._croppedImage = croppedImage
        self.imageSize = imageSize
    }
    
    // View Properties
    /// 포토 피커에서 선택된 이미지가 담길 변수
    @State private var photosItem: PhotosPickerItem?
    /// 저장될 이미지가 담길 변수
    @State private var selectedImage: UIImage?
    /// 이미지 수정창을 띄울 것인지 설정할 변수
    @State private var showImageEditView: Bool = false
    
    var body: some View {
        EmptyView()
    }
}
