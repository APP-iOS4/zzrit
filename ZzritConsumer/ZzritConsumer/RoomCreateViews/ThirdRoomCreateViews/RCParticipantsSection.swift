//
//  RCParticipantsSection.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/12/24.
//

import SwiftUI

struct RCParticipantsSection: View {
    @Binding var participantsLimit: Int
    
    var isMinimum: Bool {
        if participantsLimit <= 2 {
            return true
        } else {
            return false
        }
    }
    
    var isMaximum: Bool {
        if participantsLimit >= 10 {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        HStack {
            RoomCreateSubTitle("정원", clarification: "2~10명")
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
    }
}

#Preview {
    RCParticipantsSection(participantsLimit: .constant(2))
}
