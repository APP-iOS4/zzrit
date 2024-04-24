//
//  SwiftUIView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/24/24.
//

import SwiftUI

func LoadImageEverywhere(imagePath: String) async -> Image {
    if imagePath != "NONE" {
        if let image = await ImageCacheManager.shared.findImageFromCache(imagePath: imagePath) {
            return Image(uiImage: image)
        }
    }
    // 주소가 "NONE" 이거나 로딩해 실패했을때 로고 이미지 보냄
    return Image("ZziritLogoImage")
}
