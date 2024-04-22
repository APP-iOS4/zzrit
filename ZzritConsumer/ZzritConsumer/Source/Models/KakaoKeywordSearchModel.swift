//
//  KakaoKeywordSearchModel.swift
//  API
//
//  Created by Sanghyeon Park on 2/28/24.
//

import Foundation

// MARK: - KakaoKeywordSearchModel

struct KakaoKeywordSearchModel: Codable {
    let documents: [KakaoSearchDocumentModel]
    let meta: Meta
}

// MARK: - Document

struct KakaoSearchDocumentModel: Codable, Hashable, Identifiable {
    let addressName, categoryName, id, placeName: String
    let placeURL: String
    let roadAddressName, x, y: String

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case categoryName = "category_name"
        case id
        case placeName = "place_name"
        case placeURL = "place_url"
        case roadAddressName = "road_address_name"
        case x, y
    }
    
    
    static let sampleData = KakaoSearchDocumentModel(addressName: "서울 종로구 청진동 246", categoryName: "교육,학문 > 교육단체", id: "139255513", placeName: "멋쟁이사자처럼", placeURL: "http://place.map.kakao.com/139255513", roadAddressName: "서울 종로구 종로3길 17", x: "126.97891368495493", y: "37.570995859145405")
    
    var address: String {
        return roadAddressName == "" ? addressName : roadAddressName
    }
    
    var url: URL? {
        return URL(string: placeURL)
    }
}

// MARK: - Meta

struct Meta: Codable {
    public let isEnd: Bool
    public let pageableCount: Int
    public let sameName: SameName
    public let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case sameName = "same_name"
        case totalCount = "total_count"
    }
}

// MARK: - SameName
struct SameName: Codable {
    let keyword: String
}
