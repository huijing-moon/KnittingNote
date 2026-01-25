//
//  ContentView.swift
//  KnittingNote
//
//  Created by 문혜경 on 11/12/25.
//

import SwiftUI


struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                
                
                // 전체
                ProjectListView(status: nil, selectedTab: $selectedTab)
                    .tabItem {
                        Label("전체", systemImage: "square.grid.2x2")
                    }
                    .tag(0)
                
                // 작업 중
                ProjectListView(status: .inProgress, selectedTab: $selectedTab)
                    .tabItem {
                        Label("작업 중", systemImage: "clock")
                    }
                    .tag(1)
                
                
                // 완성
                ProjectListView(status: .completed, selectedTab: $selectedTab)
                    .tabItem {
                        Label("완성", systemImage: "checkmark.circle")
                    }
                    .tag(2)
                
                // 위시리스트
                ProjectListView(status: .wishlist, selectedTab: $selectedTab)
                    .tabItem {
                        Label("위시", systemImage: "heart")
                    }
                    .tag(3)
            }
        }
        
        
    }
}

#Preview {
    ContentView()
}
