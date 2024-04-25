//
//  LastChatModel.swift
//  ZzritConsumer
//
//  Created by Healthy on 4/25/24.
//

import Foundation
import ZzritKit

@MainActor
class LastChatModel: ObservableObject {
    // 메모리에 저장된 마지막 대화 데이터들
    @Published var lastChatDates: [String: Int] = [:]
    
    init() {
        // 디렉토리 생성 및 url 설정
        do {
            directory = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("chats")
            
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
            print("ChatCnt Saved URL: \(directory.path)")
        } catch {
            fatalError("Failed to create cache directory: \(error)")
        }
        
        // 초기 패치
        initialFetch()
    }
    
    // filemanager 저장 위치 => "앱 캐시 경로" + "chats 폴더"
    private let directory: URL
    
    /// 마지막 채팅의 Date값 저장
    func updateFile(roomID: String, lastChat: ChattingModel?) {
        guard let lastChat = lastChat else { return }
        
        let lastChatDate = Int(lastChat.date.timeIntervalSince1970 * 1000)
        
        // 파일 매니저에 저장 (경로: chats + roomID)
        let fileURL = directory.appendingPathComponent(roomID).appendingPathExtension(".txt")
        
        do {
            try "\(lastChatDate)".write(to: fileURL, atomically: true, encoding: .utf8)
            
            lastChatDates[roomID] = lastChatDate
            
            print("ChatCnt Saved URL: \(fileURL.path)")
        } catch {
            print("Error saving data to file: \(error)")
        }
    }
    
    /// roomID에 해당하는 저장된 Date값 가져오기
    private func loadFile(roomID: String) -> Int? {
        let fileURL = directory.appendingPathComponent(roomID).appendingPathExtension(".txt")
        do {
            // 파일에서 문자열 값을 불러옴
            let dataString = try String(contentsOf: fileURL, encoding: .utf8)
                        
            if var lastChatDate = Int(dataString) {
        
                lastChatDates[roomID] = lastChatDate
                
                return lastChatDate
            }
        } catch {
            print("Error loading data: \(error)")
        }
        
        return nil
    }
    
    /// 초기 패치
    func initialFetch() {
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: [])
            
            for fileURL in fileURLs {
                var roomID = fileURL.deletingPathExtension().lastPathComponent
                
                // 경로에 .이 하나 붙어서 삭제
                if roomID.last == "." {
                    roomID = String(roomID.dropLast())
                }
                
                lastChatDates[roomID] = loadFile(roomID: roomID)
            }
        } catch {
            print("\(error)")
        }
    }
}
