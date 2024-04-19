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
    
    init() {
        restAPIKey = Bundle.main.object(forInfoDictionaryKey: "Kakao Rest API Key") as? String ?? ""
    }
    
    /// 좌표를 주소로 변환합니다.
    func covertAddress(from coordinate: CLLocationCoordinate2D) async throws -> [ConvertAddressDocument] {
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
                let decodedJSONData = try JSONDecoder().decode(KakaoConverAddressModel.self, from: data)
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
        }
        
        return []
    }
}
