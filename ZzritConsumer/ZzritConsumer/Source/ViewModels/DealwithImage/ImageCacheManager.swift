//
//  File.swift
//  ZzritConsumer
//
//  Created by Irene on 4/22/24.
//

import SwiftUI

final class ImageCacheManager {
    static let shared = ImageCacheManager()
    
    private init() {
        // NSCache 저장 용량 지정
        // 이미지 개수 제한으로 200장
        self.cache.countLimit = 200
        Configs.printDebugMessage("NSCache init")
        // 이미지 용량 제한으로  약 200장
        //        self.cache.totalCostLimit = 1024 * 1024 * 250
        
        // filemanager 저장 위치 지정
        do {
            cacheDirectory = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        } catch {
            fatalError("Failed to create cache directory: \(error)")
        }
    }
    
    // filemanager 저장 위치
    private let cacheDirectory: URL
    
    // NSCache 저장 형태
    private let cache = NSCache<NSString, UIImage>()
    
    
    // MARK: 이미지 저장하기

    // NSCache에 업데이트
    // TODO: updateToNSCache로 변경
    func updateToCache(name: String, image: UIImage?) {
        guard let image = image else { return }
        cache.setObject(image, forKey: name as NSString)
        Configs.printDebugMessage("NSCache에 업데이트")
    }
    
    // filemanager에 업데이트
    private func updateToFileManager(name: String, image: UIImage?) {
        // / 있으면 안되서 주소 변경
        let encodedImageName = name.replacingOccurrences(of: "/", with: "_")
        // 넣을 path 지정
        let imagePath = cacheDirectory.appendingPathComponent(encodedImageName)
        guard let imageData = image!.pngData() else { return }
        
        do {
            // filemanager에 로드
            try imageData.write(to: imagePath)
            Configs.printDebugMessage("filemanager에 업데이트")
        } catch {
            Configs.printDebugMessage("Failed to save image to cache: \(error)")
        }
    }
    
    // 사용자가 처음 파베로 올릴때
    // TODO: 바깥 세상의 updateToNSCache는 모두 updateImageFirst로 변경한다.
    func updateImageFirst(name: String, image: UIImage?) {
        updateToCache(name: name, image: image)
        updateToFileManager(name: name, image: image)
    }
    
    // MARK: 이미지 로드 받아오기
    
    // NSCache로부터 로드
    func loadFromNSCacheImage(imageURL: String) -> UIImage? {
        Configs.printDebugMessage("NSCache에서 불러오기")
        return cache.object(forKey: imageURL as NSString)
    }
    
    // filemanager로부터 로드
    func loadFromFilemanagerImage(imageURL: String) -> UIImage? {
        // / 있으면 안되서 주소 변경
        let encodedImageName = imageURL.replacingOccurrences(of: "/", with: "_")
        
        // 찾을 파일 이름을 갖고 경로 설정
        let imagePath = cacheDirectory.appendingPathComponent(encodedImageName)
        guard FileManager.default.fileExists(atPath: imagePath.path) else { return nil }
        
        do {
            Configs.printDebugMessage("filemanager에서 불러오기")
            // 사진 찾아와서 UIImage로 return
            let imageData = try Data(contentsOf: imagePath)
            return UIImage(data: imageData)
        } catch {
            Configs.printDebugMessage("Failed to load image from cache: \(error)")
            return nil
        }
    }
    
    // 캐시에서 이미지 찾기
    func findImageFromCache(imageURL: String) async -> UIImage? {
        // NSCache에서 찾기
        if let nsCacheImage = loadFromNSCacheImage(imageURL: imageURL) {
            return nsCacheImage
        } else {
            // filemanager에서 찾기
            if let filemanagerImage = loadFromFilemanagerImage(imageURL: imageURL) {
                return filemanagerImage
            } else {
                // 파베로부터 다운받아오기
                if let data = try? Data(contentsOf: URL(string: imageURL)!) {
                    // url로 부터 이미지 받아오기
                    guard let loadImageFromFB = UIImage(data: data) else { return nil }
                    Configs.printDebugMessage("파베에서 받아와서 ~")
                    
                    // filemanager 저장
                    updateToFileManager(name: imageURL, image: loadImageFromFB)
                    
                    // NSCache 저장
                    updateToCache(name: imageURL, image: loadImageFromFB)
                    return loadImageFromFB
                }
            }
        }
        Configs.printDebugMessage("파베에도 없음")
        return nil
    }
}


// 출처 : https://velog.io/@oasis444/이미지-캐시-처리
// 출처 : https://nsios.tistory.com/58
