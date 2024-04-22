//
//  OfflineLocationListCell.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/21/24.
//

import SwiftUI

struct OfflineLocationListCell: View {
    let locationModel: KakaoSearchDocumentModel
    let keyword: String
    
    @Environment(\.dismiss) private var dismiss
    
    private var address: String {
        if locationModel.roadAddressName != "" {
            return locationModel.roadAddressName
        } else {
            return locationModel.addressName
        }
    }
    
    private var addressType: String {
        locationModel.roadAddressName == "" ? "지번" : "도로명"
    }
    
    private var placeNameAttributedString: AttributedString {
        var attributedString = AttributedString(locationModel.placeName)
        if let range = attributedString.range(of: keyword) {
            attributedString[range].foregroundColor = Color.pointColor
        }
        return attributedString
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading) {
                Text(placeNameAttributedString)
                    .font(.title3.bold())
                HStack {
                    Text(addressType)
                        .foregroundStyle(Color.staticGray3)
                        .font(.callout.bold())
                        .padding(5)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundStyle(Color.staticGray6)
                        }
                    Text(address)
                        .foregroundStyle(Color.staticGray2)
                }
            }
            .padding()
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color.staticGray5)
        }
        .onTapGesture {
            let latitude = Double(locationModel.y) ?? 0.0
            let longitude = Double(locationModel.x) ?? 0.0
            let location: OfflineLocationModel = .init(placeName: locationModel.placeName, address: address, latitude: latitude, longitude: longitude)
            selectLocation(location: location)
        }
    }
    
    private func selectLocation(location: OfflineLocationModel) {
        LocalStorage.shared.addLocationHistory(location: location)
        dismiss()
    }
}

//#Preview {
//    OfflineLocationListCell()
//}
