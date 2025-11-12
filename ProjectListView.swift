//
//  ProjectListView.swift
//  KnittingNote
//
//  Created by 문혜경 on 11/12/25.
//

import SwiftUI

struct ProjectListView: View {
    @EnvironmentObject var store: ProjectStore
    @State private var showingAdd = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(store.projects) { project in
                            NavigationLink(destination: ProjectDetailView(project: project)) {
                                ProjectCardView(project: project)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                }
                
                // ➕ 플로팅 버튼
                Button {
                    showingAdd = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.accentColor)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .padding()
            }
            .navigationTitle("🧶 KnitNote")
            .sheet(isPresented: $showingAdd) {
                AddProjectView()
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}

struct ProjectCardView: View {
    let project: KnitProject
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let image = project.image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 160)
                    .clipped()
                    .cornerRadius(15)
            } else {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 160)
                    .overlay(Text("📸 사진 없음").foregroundColor(.gray))
            }
            
            Text(project.title)
                .font(.headline)
            
            
            HStack {
                            Label("\(project.currentRow)단", systemImage: "number.circle")
                            Spacer()
                            Label(project.yarn, systemImage: "scissors")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.08), radius: 5, x: 0, y: 3)
                }
            }
