//
//  MoreInfoListView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/9/24.
//

import SwiftUI

struct MoreInfoListView: View {
    var body: some View {
        VStack {
            FakeDivider()
            VStack(alignment: .leading, spacing: 40) {
                // 공지사항
                Button {
                    
                } label: {
                    HorizontalLabel(string: "공지사항")
                }
                
                // 버전 정보
                HStack {
                    Text("버전 정보")
                    Spacer()
                    Text("최신 버전")
                        .foregroundStyle(Color.staticGray4)
                }
                // 자주 묻는 질문
                Button {
                    
                } label: {
                    HorizontalLabel(string: "자주 묻는 질문")
                    
                }
                
                // 문의하기
                Button {
                    
                } label: {
                    HorizontalLabel(string: "문의하기")
                }
            }
            .padding(Configs.paddingValue)
            
            FakeDivider()
            VStack(alignment: .leading, spacing: 40) {
                // 이용약관
                Button {
                    
                } label: {
                    HorizontalLabel(string: "이용약관")
                }
                
                // 개인정보처리방침
                Button {
                    
                } label: {
                    HorizontalLabel(string: "개인정보처리방침")
                }
            }
            .padding(Configs.paddingValue)
            
            FakeDivider()
            VStack(alignment: .leading, spacing: 40) {
                // 로그아웃
                Button {
                    
                } label: {
                    HorizontalLabel(string: "로그아웃")
                        .foregroundStyle(.red)
                }
            }
            .padding(Configs.paddingValue)
            
            FakeDivider()
        }
        .foregroundStyle(Color.staticGray1)
    }
}

struct FakeDivider: View {
    var body: some View {
        Rectangle()
            .frame(height: 10)
            .foregroundStyle(Color.staticGray5)
    }
}

struct HorizontalLabel: View {
    var string: String
    var body: some View {
            HStack {
                Text(string)
                Spacer()
            }
    }
}

#Preview {
    MoreInfoListView()
}
