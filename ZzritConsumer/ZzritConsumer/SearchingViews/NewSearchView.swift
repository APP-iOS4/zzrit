//
//  NewSearchView.swift
//  ZzritConsumer
//
//  Created by SunJoon Lee on 4/17/24.
//

import SwiftUI

struct NewSearchView: View {
    @State var searchText: String = ""
    
    var body: some View {
        SearchFieldView()
        
        HStack(spacing: 10.0) {
            Button {
                
            } label: {
                Image(systemName: "arrow.counterclockwise.circle.fill")
            }
            .foregroundStyle(Color.pointColor)
            
            Button {
               
            } label: {
                Label("위치", systemImage: "scope")
                    .foregroundStyle(.black)
                    .padding(.vertical, 5.0)
                    .padding(.horizontal, 10.0)
                    .overlay {
                        RoundedRectangle(cornerRadius: Configs.cornerRadius)
                            .strokeBorder(Color.staticGray4, lineWidth: 1.0)
                    }
            }
            
            Menu {
                
                // 필터
                Button {
                    
                } label: {
                    Text("필터1")
                }
                
                // 필터
                Button {
                    
                } label: {
                    Text("필터2")
                }
                
            } label: {
                HStack {
                    Label("카테고리", systemImage: "chevron.down")
                        .foregroundStyle(.black)
                        .padding(.vertical, 5.0)
                        .padding(.horizontal, 10.0)
                        .overlay {
                            RoundedRectangle(cornerRadius: Configs.cornerRadius)
                                .strokeBorder(Color.staticGray4, lineWidth: 1.0)
                        }
                }
            }
            
            Menu {
                // 필터
                Button {
                    
                } label: {
                    Text("필터1")
                }
                
                // 필터
                Button {
                    
                } label: {
                    Text("필터2")
                }
                
            } label: {
                HStack {
                    Label("모임 날짜", systemImage: "chevron.down")
                        .foregroundStyle(.black)
                        .padding(.vertical, 5.0)
                        .padding(.horizontal, 10.0)
                        .overlay {
                            RoundedRectangle(cornerRadius: Configs.cornerRadius)
                                .strokeBorder(Color.staticGray4, lineWidth: 1.0)
                        }
                }
            }
        }
        .lineLimit(2)
        .padding(.vertical, Configs.paddingValue)
    }
}

#Preview {
    NewSearchView()
}
