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

        let filtered: [Int]
        if let status {
            filtered = indices.filter { store.projects[$0].status == status }
        } else {
            filtered = Array(indices)
        }

        let sorted = filtered.sorted { a, b in
            if store.projects[a].isFavorite != store.projects[b].isFavorite {
                return store.projects[a].isFavorite
            }
            return false
        }
        return sorted.map { $store.projects[$0] }
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(projectsToShow) { $project in
                        NavigationLink {
                            ProjectDetailView(
                                project: $project,
                                selectedTab: $selectedTab
                            )
                        } label: {
                            ProjectCardView(project: project)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 80)
            }
            .background(Color(.systemGroupedBackground))

            // ➕ 플로팅 버튼
            Button {
                showingAdd = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(
                        LinearGradient(
                            colors: [Color.accentColor, Color.accentColor.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                    .shadow(color: Color.accentColor.opacity(0.4), radius: 8, x: 0, y: 4)
            }
            .padding(.trailing, 20)
            .padding(.bottom, 20)
        }
        .sheet(isPresented: $showingAdd) {
            AddProjectView()
        }
    }
}

// MARK: - ProjectCardView
struct ProjectCardView: View {
    let project: KnitProject
    @EnvironmentObject var store: ProjectStore
    @State private var showDeleteAlert = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // MARK: - 이미지 영역
            ZStack(alignment: .topTrailing) {
                // 이미지 또는 플레이스홀더
                if let image = project.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 180)
                        .clipped()
                } else {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color(.systemGray5), Color(.systemGray6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 180)
                        .overlay(
                            VStack(spacing: 8) {
                                Image(systemName: "heart.text.clipboard")
                                    .font(.system(size: 36))
                                    .foregroundColor(Color(.systemGray3))
                                Text("사진 없음")
                                    .font(.caption)
                                    .foregroundColor(Color(.systemGray3))
                            }
                        )
                }

                // 하단 그라데이션 + 제목
                VStack {
                    Spacer()
                    HStack {
                        Text(project.title)
                            .font(.title3.bold())
                            .foregroundColor(.white)
                            .lineLimit(1)
                        Spacer()
                    }
                    .padding(.horizontal, 14)
                    .padding(.bottom, 12)
                    .background(
                        LinearGradient(
                            colors: [.clear, .black.opacity(0.6)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }

                // 상태 배지
                Text(project.status.displayName)
                    .font(.caption2.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(statusColor(for: project.status))
                    )
                    .padding(10)

                // 즐겨찾기 버튼
                VStack {
                    HStack {
                        Button {
                            store.toggleFavorite(project)
                        } label: {
                            Image(systemName: project.isFavorite ? "star.fill" : "star")
                                .font(.body.weight(.semibold))
                                .foregroundColor(project.isFavorite ? .yellow : .white.opacity(0.8))
                                .padding(8)
                                .background(.ultraThinMaterial, in: Circle())
                        }
                        .buttonStyle(.plain)
                        .padding(10)
                        Spacer()
                    }
                    Spacer()
                }
            }
            .clipped()

            // MARK: - 정보 영역
            VStack(alignment: .leading, spacing: 8) {
                // 실 + 바늘
                HStack(spacing: 16) {
                    Label {
                        Text(project.yarn)
                            .lineLimit(1)
                    } icon: {
                        Image(systemName: "scissors")
                            .foregroundColor(.accentColor)
                    }

                    if !project.needle.isEmpty {
                        Label {
                            Text(project.needle)
                                .lineLimit(1)
                        } icon: {
                            Image(systemName: "paintbrush.pointed")
                                .foregroundColor(.orange)
                        }
                    }

                    Spacer()
                }
                .font(.caption)
                .foregroundColor(.secondary)

                // 단수 요약
                if !project.rowCounters.isEmpty {
                    HStack(spacing: 6) {
                        Image(systemName: "number")
                            .font(.caption2)
                            .foregroundColor(.accentColor)
                        Text(project.rowSummaryText)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .contextMenu {
            Button {
                store.toggleFavorite(project)
            } label: {
                Label(
                    project.isFavorite ? "즐겨찾기 해제" : "즐겨찾기",
                    systemImage: project.isFavorite ? "star.slash" : "star.fill"
                )
            }
            Button(role: .destructive) {
                showDeleteAlert = true
            } label: {
                Label("삭제", systemImage: "trash")
            }
        }
        .alert("프로젝트를 삭제할까요?", isPresented: $showDeleteAlert) {
            Button("삭제", role: .destructive) {
                store.delete(project)
            }
            Button("취소", role: .cancel) {}
        } message: {
            Text("'\(project.title)' 프로젝트가 영구적으로 삭제됩니다.")
        }
    }

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
