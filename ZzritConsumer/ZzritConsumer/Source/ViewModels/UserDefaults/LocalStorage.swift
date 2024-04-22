//
//  LocalStorage.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/22/24.
//

import Foundation

class LocalStorage {
    static let shared = LocalStorage()
    
    private let jsonEncoder = JSONEncoder()
    private let jsonDecoder = JSONDecoder()
    
    func addLocationHistory(location: OfflineLocationModel) {
        var locationHistories = locationHistories()
        
        locationHistories.insert(location, at: 0)
        let data = try? jsonEncoder.encode(locationHistories)
        UserDefaults.standard.set(data, forKey: "OfflineSearchHistories")
    }
    
    func locationHistories() -> [OfflineLocationModel] {
        do {
            if let data = UserDefaults.standard.data(forKey: "OfflineSearchHistories") {
                let decodedData: [OfflineLocationModel] = try jsonDecoder.decode([OfflineLocationModel].self, from: data)
                return decodedData
            }
        } catch {
            print("에러 \(error)")
        }
        return []
    }
    
    func deleteHistory(at index: Int) {
        var histories = locationHistories()
        histories.remove(at: index)
        let data = try? jsonEncoder.encode(histories)
        UserDefaults.standard.set(data, forKey: "OfflineSearchHistories")
    }
    
    func clearHistory() {
        UserDefaults.standard.removeObject(forKey: "OfflineSearchHistories")
    }
    
    func setCurrentLocation(location: OfflineLocationModel) {
        let data = try? jsonEncoder.encode(location)
        UserDefaults.standard.set(data, forKey: "LatestOfflineLocation")
    }
    
    func latestSettedLocation() -> OfflineLocationModel? {
        do {
            if let data = UserDefaults.standard.data(forKey: "LatestOfflineLocation") {
                let decodedData: OfflineLocationModel = try jsonDecoder.decode(OfflineLocationModel.self, from: data)
                return decodedData
            }
        } catch {
            print("에러 \(error)")
        }
        return nil
    }
}
