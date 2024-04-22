//
//  KakaoKeywordSearchService.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/19/24.
//

import CoreLocation
import Foundation

class KakaoSearchService {
    private let restAPIKey: String
    
    // MARK: 키워드 장소검색시 필요한 프로퍼티
    
    private var recentKeyword: String = ""
    private var page: Int = 1
    var isEnd: Bool = false
    
    init() {
        restAPIKey = Bundle.main.object(forInfoDictionaryKey: "Kakao Rest API Key") as? String ?? ""
    }
    
    /// 좌표를 주소로 변환합니다.
    func convertAddress(from coordinate: CLLocationCoordinate2D) async throws -> [ConvertAddressDocument] {
        print("\(#function)")
        let apiURL = "https://dapi.kakao.com/v2/local/geo/coord2address"
        
        // 입력받은 좌표를 토대로 API URL을 생성하고 올바르지 않을경우, 에러 throw
        guard let url = URL(string: "\(apiURL)?x=\(coordinate.longitude)&y=\(coordinate.latitude)") else {
            throw KakaoSearchError.invalidUrl
        }
        
        // API 키가 없을 경우, 에러 throw
        guard restAPIKey != "" else {
            throw KakaoSearchError.invalidApiKey
        }
        
        var request = URLRequest(url: url)
        request.addValue("KakaoAK \(restAPIKey)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let response = response as? HTTPURLResponse {
            switch response.statusCode {
            case 200...299:
                let decodedJSONData = try JSONDecoder().decode(KakaoConvertAddressModel.self, from: data)
                return decodedJSONData.documents
            case 300...399:
                throw KakaoSearchError.redirection
            case 400...499:
                throw KakaoSearchError.clientError
            case 500...599:
                throw KakaoSearchError.serverError
            default:
                throw KakaoSearchError.unknowned
            }
        } else {
            throw KakaoSearchError.unknowned
        }
    }
    
    /// 키워드로 장소를 검색합니다.
    func keywordSearch(keyword: String, coordinate: CLLocationCoordinate2D? = nil) async throws -> [KakaoSearchDocumentModel] {
        let apiURL = "https://dapi.kakao.com/v2/local/search/keyword"
        
        // 검색 단어가 없을 경우, 리스트를 초기화 하고 함수 종료
        if keyword == "" {
            recentKeyword = ""
            return []
        }
        
        // 스토어에 저장된 검색어가 달라지지 않은 경우, 다음 페이지 검색으로 간주한다
        if recentKeyword == keyword {
            page += 1
        } else {
            // 새로운 키워드로 검색할 경우 페이징 초기화
            page = 1
        }
        
        // 들어온 키워드를 스토어에 저장함 (페이징 처리를 위해)
        recentKeyword = keyword
        
        // URL 변환에 실패했을 경우 오류 반환
        guard let url = URL(string: "\(apiURL)?query=\(keyword)&page=\(page)") else {
            throw KakaoSearchError.invalidUrl
        }
        
        // API 키가 없을 경우, 에러 throw
        guard restAPIKey != "" else {
            throw KakaoSearchError.invalidApiKey
        }
        
        var request = URLRequest(url: url)
        request.addValue("KakaoAK \(restAPIKey)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let response = response as? HTTPURLResponse {
            switch response.statusCode {
            case 200...299:
                let decodedJsonData = try JSONDecoder().decode(KakaoKeywordSearchModel.self, from: data)
                
                // 마지막 페이지 여부를 넣어줌 (페이징을 위해)
                self.isEnd = decodedJsonData.meta.isEnd
                return decodedJsonData.documents
            case 300...399:
                throw KakaoSearchError.redirection
            case 400...499:
                throw KakaoSearchError.clientError
            case 500...599:
                throw KakaoSearchError.serverError
            default:
                throw KakaoSearchError.unknowned
            }
        } else {
            throw KakaoSearchError.unknowned
        }
    }
}
