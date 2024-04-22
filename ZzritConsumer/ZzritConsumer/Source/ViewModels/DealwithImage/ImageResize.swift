//
//  ImageResize.swift
//  ZzritConsumer
//
//  Created by Irene on 4/22/24.
//

import SwiftUI

extension UIImage {
    // 이미지 크기 조절 일단 넓이 기준
    // 채팅의 이미지 최대 : 1024
    // 프로필 이미지 최대 : 300
    // 모임방 이미지 최대 : 840
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}

//    출처: https://jkim68888.tistory.com/3 [Jihyun Kim:티스토리]
