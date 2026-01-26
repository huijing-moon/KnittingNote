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
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
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

// ⭐️ ProjectCardView를 밖으로 이동
struct ProjectCardView: View {
    let project: KnitProject
    @EnvironmentObject var store: ProjectStore
    @State private var showDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            // MARK: - 이미지 + 상태 배지
            ZStack(alignment: .topTrailing) {
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
                
                // ⭐️ 상태 배지
                Text(project.status.displayName)
                    .font(.caption.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(statusColor(for: project.status))
                    .cornerRadius(12)
                    .padding(8)
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
        .contextMenu {
                  Button(role: .destructive) {
                      showDeleteAlert = true
                  } label: {
                      Label("삭제", systemImage: "trash")
                  }
              }
              .alert("프로젝트를 삭제할까요?", isPresented: $showDeleteAlert) {
                  Button("삭제", role: .destructive) {
                      store.delete(project)  // ⭐️ 이렇게 수정
                  }
                  Button("취소", role: .cancel) {}
              } message: {
                  Text("'\(project.title)' 프로젝트가 영구적으로 삭제됩니다.")
              }
          }
    
    // ⭐️ 상태별 색상
    private func statusColor(for status: ProjectStatus) -> Color {
        switch status {
        case .wishlist:
            return Color.blue
        case .inProgress:
            return Color.orange
        case .completed:
            return Color.green
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

