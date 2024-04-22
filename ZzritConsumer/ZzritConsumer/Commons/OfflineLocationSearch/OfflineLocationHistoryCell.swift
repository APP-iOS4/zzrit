//
//  OfflineLocationHistoryCell.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/22/24.
//

import SwiftUI

struct OfflineLocationHistoryCell: View {
    let locationModel: OfflineLocationModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading) {
                Text(locationModel.placeName)
                    .font(.title3.bold())
                Text(locationModel.address)
                    .foregroundStyle(Color.staticGray2)
            }
            .padding()
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color.staticGray5)
        }
    }
}
