//
//  File.swift
//  ZzritConsumer
//
//  Created by Irene on 4/22/24.
//

import SwiftUI

final class ImageCacheManager {
    static let shared = ImageCacheManager()
    
    // 캐시 저장 용량 지정
    private init() {
        // 이미지 개수 제한으로 250장
        self.cache.countLimit = 250
        
        // 이미지 용량 제한으로  약 250장
        //        self.cache.totalCostLimit = 1024 * 1024 * 250
    }
    
    // 캐시 저장 형태
    private let cache = NSCache<NSString, UIImage>()
    
    // 캐시에 업데이트
    // 1. 사용자가 사진을 올릴때
    // 2. 필요한 사진이 캐시에 사진이 없을때
    func updateToCache(name: String, image: UIImage?) {
        guard let image = image else { return }
        cache.setObject(image, forKey: name as NSString)
        print("캐시에 업데이트 \(name)")
    }
    
    // 캐시로부터 로드
    // View에서 이미지를 보여줘야 할 때
    func cachedImage(imageURL: String) -> UIImage? {
        cache.object(forKey: imageURL as NSString)
    }
    
    // 캐시에서 이미지 찾기
    func findImageFromCache(imageURL: String) async -> UIImage? {
        // 캐시에 이미지가 존재했을때
        if let image = cachedImage(imageURL: imageURL) {
            return image
        } else {
            // 캐시에 이미지가 없을 때 파베로부터 다운받아오기
            if let data = try? Data(contentsOf: URL(string: imageURL)!) {
                // url로 부터 이미지 받아오기
                guard let loadImageFromFB = UIImage(data: data) else { return nil }
                // 불러온 이미지 캐시에 저장
                updateToCache(name: imageURL, image: loadImageFromFB)
                return loadImageFromFB
            }
        }
        print("파베에도 없음")
        return nil
    }
}


// 출처 : https://velog.io/@oasis444/이미지-캐시-처리
