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
    let status: ProjectStatus?
    @Binding var selectedTab: Int
    
    var projectsToShow: [Binding<KnitProject>] {
         let indices = store.projects.indices

         if let status {
             return indices
                 .filter { store.projects[$0].status == status }
                 .map { $store.projects[$0] }
         } else {
             return indices.map { $store.projects[$0] }
         }
     }
    
    var filteredProjectIndices: [Int] {
        store.projects.indices.filter {
            store.projects[$0].status == status
        }
    }
    
    var body: some View {
      
            ZStack(alignment: .bottomTrailing) {
                // 부모 뷰 (List 부분)
                // ProjectListView.swift

                List {
                    ForEach(projectsToShow) { $project in
                        NavigationLink {
                            ProjectDetailView(
                                project: $project,
                                selectedTab: $selectedTab
                            )
                        } label: {
                            ProjectCardView(project: project)
                        }

                        
                    }

                }
                .listStyle(.plain)
                
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
            .sheet(isPresented: $showingAdd) {
                AddProjectView()
            }
        }
    
}

// ⭐ 섹션 헤더 UI
@ViewBuilder
func sectionHeader(_ title: String) -> some View {
    HStack {
        Text(title)
            .font(.title3.bold())
            .foregroundColor(.primary)
        Spacer()
    }
    .padding(.horizontal, 4)
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
            

            
                        HStack {
                            if !project.rowCounters.isEmpty {
                                Text(project.rowSummaryText)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
            
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
