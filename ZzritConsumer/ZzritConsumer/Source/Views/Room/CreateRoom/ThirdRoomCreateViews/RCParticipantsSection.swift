//
//  RCParticipantsSection.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/12/24.
//

import SwiftUI

struct RCParticipantsSection: View {
    
    @EnvironmentObject private var purchaseViewModel: PurchaseViewModel
    
    @Binding var participantsLimit: Int
    @Binding var limitMaxmium: Int
    
    var isMinimum: Bool {
        if participantsLimit <= 2 {
            return true
        } else {
            return false
        }
    }
    
    var isMaximum: Bool {
        if participantsLimit >= limitMaxmium {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        HStack {
            RCSubTitle("정원", clarification: "2~\(limitMaxmium)명")
                .lineLimit(1)
            
            ZStack {
                HStack(alignment: .center ,spacing: 15.0) {
                    Button {
                        participantsLimit -= 1
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundStyle(isMinimum ? Color.staticGray5 : Color.pointColor)
                    }
                    .disabled(isMinimum)
                    
                    Text("\(20)")
                        .foregroundStyle(.background)
                    
                    Button {
                        participantsLimit += 1
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(isMaximum ? Color.staticGray5 : Color.pointColor)
                    }
                    .disabled(isMaximum)
                }
                Text("\(participantsLimit)")
            }
        }
        .customOnChange(of: limitMaxmium) { _ in
            if participantsLimit >= limitMaxmium {
                participantsLimit = limitMaxmium
            }
        }
        .customOnChange(of: purchaseViewModel.isPurchased) { newValue in
            if newValue {
                participantsLimit = 99
            }
        }
    }
}

#Preview {
    RCParticipantsSection(participantsLimit: .constant(2), limitMaxmium: .constant(10))
}
