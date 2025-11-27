//
//  ContentView.swift
//  KnittingNote
//
//  Created by 문혜경 on 11/12/25.
//

import SwiftUI


struct ContentView: View {
  

    var body: some View {
        TabView {
            ProjectListView(status: .inProgress)
                .tabItem {
                    Label("작업 중", systemImage: "hammer")
                }

            ProjectListView(status: .completed)
                .tabItem {
                    Label("완성", systemImage: "checkmark.circle")
                }

            ProjectListView(status: .wishlist)
                .tabItem {
                    Label("위시리스트", systemImage: "star")
                }
        }
       
    }
}

#Preview {
    ContentView()
}
