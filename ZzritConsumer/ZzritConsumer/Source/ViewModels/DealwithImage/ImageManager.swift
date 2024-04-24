//
//  SwiftUIView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/24/24.
//

import SwiftUI
import ZzritKit

final class ImageManager {
    private var storageService = StorageService()
    
    // 이미지 불러오기
    func loadImage(imagePath: String) async -> Image {
        if imagePath != "NONE" {
            if let image = await ImageCacheManager.shared.findImageFromCache(imagePath: imagePath) {
                return Image(uiImage: image)
            }
        }
        // 주소가 "NONE" 이거나 로딩해 실패했을때 로고 이미지 보냄
        return Image("ZziritLogoImage")
    }
    
    // 이미지 업로드
    // 성공시 firebase Storage 디렉토리 주소 - 실패시 NONE
    func uploadImage(image: UIImage?, storageName: StorageService.StorageName, path: [String]) -> String {
        // 이미지 없을 때
        guard let userUploadImage = image else { return "NONE"}
        // 이미지 경로 설정
        let imageDir: [StorageService.StorageName: [String]] = [storageName: path]
        
        // 이미지 크기조정 후 업로드와 캐시에 이미지 로드
        switch storageName {
        case .profile:
            // 프로필 사진 최대 300
            guard let resizeImage = (userUploadImage.size.width) < 300 ? userUploadImage : userUploadImage.resizeWithWidth(width: 300) else { return "NONE" }
            guard let imageData = resizeImage.pngData() else { return "NONE" }
            Task {
                do {
                    guard let getPath = try await storageService.imageUpload(dirs: imageDir, image: imageData) else { return "NONE" }
                    ImageCacheManager.shared.updateImageFirst(name: getPath, image: resizeImage)
                    return getPath
                } catch {
                    Configs.printDebugMessage("Failed : \(error)\n")
                    return "NONE"
                }
            }
        case .roomCover:
            // 모임방 사진 최대 840
            guard let resizeImage = (userUploadImage.size.width) < 840 ? userUploadImage : userUploadImage.resizeWithWidth(width: 840) else { return "NONE" }
            guard let imageData = resizeImage.pngData() else { return "NONE" }
            
            Task {
                do {
                    guard let getPath = try await storageService.imageUpload(dirs: imageDir, image: imageData) else { return "NONE" }
                    ImageCacheManager.shared.updateImageFirst(name: getPath, image: resizeImage)
                    return getPath
                } catch {
                    Configs.printDebugMessage("Failed : \(error)\n")
                    return "NONE"
                }
            }
        case .chatting:
            // 채팅 사진 최대 1024
            guard let resizeImage = (userUploadImage.size.width) < 1024 ? userUploadImage : userUploadImage.resizeWithWidth(width: 1024) else { return "NONE" }
            guard let imageData = resizeImage.pngData() else { return "NONE" }
            
            Task {
                do {
                    guard let getPath = try await storageService.imageUpload(dirs: imageDir, image: imageData) else { return "NONE" }
                    ImageCacheManager.shared.updateImageFirst(name: getPath, image: resizeImage)
                    return getPath
                } catch {
                    Configs.printDebugMessage("Failed : \(error)\n")
                    return "NONE"
                }
            }
        }
        return "NONE"
    }
}

