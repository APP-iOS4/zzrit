//
//  VoteViewModel.swift
//  ZzritConsumer
//
//  Created by Healthy on 4/30/24.
//

import Foundation

class RoomVoteViewModel: ObservableObject {
    
    // filemanager 저장 위치 => "앱 캐시 경로" + "votes 폴더"
    private let directory: URL
    
    private(set) var isDeleteFileInit: Bool = true

    init() {
        // 디렉토리 생성 및 url 설정
        do {
            directory = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("votes")
            
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
            print("ChatCnt Saved URL: \(directory.path)")
        } catch {
            fatalError("Failed to create applicationSupportDirectory directory: \(error)")
        }
    }

    func checkRoomToVote(fetchedRoomIDs: [String]) -> [String] {
        let votedRoomIDs = loadVotedRoomIDs()

        // 첫 fetch시 파일 정리
        if isDeleteFileInit {
            deleteRemovedRoomIDs(fetchedRoomIDs: fetchedRoomIDs, votedRoomIDs: votedRoomIDs)
            isDeleteFileInit = false
        }
        
        // 서버에는 있고 로컬에는 없는 모임 비교
        let roomIDsToVote = fetchedRoomIDs.filter { !votedRoomIDs.contains($0) }
        // 투표해야할 ID값 리턴
        return roomIDsToVote
    }
    
    private func deleteRemovedRoomIDs(fetchedRoomIDs: [String], votedRoomIDs: [String]) {
        // 서버에는 없고 로컬에는 있는 모임 비교
        let roomIDsToRemove = votedRoomIDs.filter { !fetchedRoomIDs.contains($0) }
        deleteRoomIDs(roomIDs: roomIDsToRemove)
    }
    
    /// 투표한 방의 ID값 배열로 파일 매니저에 저장
    func addVoteRoomID(roomID: String) {
        // 파일 매니저 경로 설정 (경로: votes + votes)
        let fileURL = directory.appendingPathComponent("votes").appendingPathExtension(".txt")
        
        do {
            // 기존에 저장한 배열
            var votedRoomIDs = loadVotedRoomIDs()
            
            // 중복 저장 방지
            if votedRoomIDs.contains(roomID) {
                return
            }
            
            // 기존 배열에 추가
            votedRoomIDs.append(roomID)
            
            // 파일에 저장
            let data = try JSONEncoder().encode(votedRoomIDs)
            try data.write(to: fileURL)
            
            print("votedRoomIDs Saved URL: \(fileURL.path)")
        } catch {
            print("Error saving data to file: \(error)")
        }
    }
    
    /// 파일 매니저에 저장된 투표한 방 ID값들 가져오기
    private func loadVotedRoomIDs() -> [String] {
        // 파일 경로 "앱 캐시 경로" + "votes 폴더" + "votes.txt 파일"
        let fileURL = directory.appendingPathComponent("votes").appendingPathExtension(".txt")
        
        do {
            let data = try Data(contentsOf: fileURL)
            let loadedItems = try JSONDecoder().decode([String].self, from: data)
            return loadedItems
        } catch {
            print("Error loading data: \(error)")
        }
        
        return []
    }
    
    /// 특정 방들의 ID값 삭제
    func deleteRoomIDs(roomIDs: [String]) {
        // 파일 매니저 경로 설정 (경로: votes + votes)
        let fileURL = directory.appendingPathComponent("votes").appendingPathExtension(".txt")
        
        // 기존에 저장한 배열
        var votedRoomIDs = loadVotedRoomIDs()
        
        // votedRoomIDs 배열에서 roomIDs 배열에 있는 값을 제거
        votedRoomIDs.removeAll { roomIDs.contains($0) }
        
        // ID값이 삭제된 배열로 저장
        do {
            // 파일에 저장
            let data = try JSONEncoder().encode(votedRoomIDs)
            try data.write(to: fileURL)
            
            print("votedRoomIDs Saved URL: \(fileURL.path)")
        } catch {
            print("Error saving data to file: \(error)")
        }
    }
}
