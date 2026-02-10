//
//  ProjectDetialView.swift
//  KnittingNote
//
//  Created by 문혜경 on 11/12/25.
//

import SwiftUI

struct ProjectDetailView: View {
    @EnvironmentObject var store: ProjectStore
    @Binding var project: KnitProject

    @State private var showDeleteAlert = false
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = nil
    @Binding var selectedTab: Int

    init(project: Binding<KnitProject>, selectedTab: Binding<Int>) {
        self._project = project
        self._selectedTab = selectedTab
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // MARK: - 사진 영역
                ZStack(alignment: .bottomTrailing) {
                    if let image = project.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 260)
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .overlay(
                                LinearGradient(
                                    colors: [.clear, .clear, .black.opacity(0.15)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    } else {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(.systemGray5), Color(.systemGray6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 200)
                            .overlay(
                                VStack(spacing: 12) {
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 36))
                                        .foregroundColor(Color(.systemGray3))
                                    Text("사진을 추가해보세요")
                                        .font(.subheadline)
                                        .foregroundColor(Color(.systemGray3))
                                }
                            )
                    }

                    // 사진 추가/변경 버튼
                    HStack(spacing: 10) {
                        if project.photoData != nil {
                            Button {
                                showDeleteAlert = true
                            } label: {
                                Image(systemName: "trash")
                                    .font(.callout)
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(.ultraThinMaterial, in: Circle())
                            }
                        }

                        Button {
                            showImagePicker = true
                        } label: {
                            Image(systemName: project.photoData != nil ? "camera.fill" : "plus.circle.fill")
                                .font(.callout)
                                .foregroundColor(.white)
                                .padding(10)
                                .background(.ultraThinMaterial, in: Circle())
                        }
                    }
                    .padding(12)
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
                .padding(.horizontal)

                // MARK: - 프로젝트 정보 섹션
                VStack(alignment: .leading, spacing: 16) {
                    // 제목
                    Text(project.title)
                        .font(.title.bold())
                        .foregroundColor(.primary)

                    // 상태 피커
                    Picker("상태", selection: $project.status) {
                        ForEach(ProjectStatus.allCases, id: \.self) {
                            Text($0.displayName).tag($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: project.status) { newValue in
                        saveChange()
                        selectedTab = 0
                    }

                    Divider()

                    // 실 + 바늘
                    HStack(spacing: 12) {
                        HStack(spacing: 6) {
                            Image(systemName: "scissors")
                                .foregroundColor(.accentColor)
                                .frame(width: 20)
                            TextField("실 이름", text: $project.yarn)
                                .textFieldStyle(.roundedBorder)
                                .onSubmit { saveChange() }
                        }
                        HStack(spacing: 6) {
                            Image(systemName: "paintbrush.pointed")
                                .foregroundColor(.orange)
                                .frame(width: 20)
                            TextField("바늘 이름", text: $project.needle)
                                .textFieldStyle(.roundedBorder)
                                .onSubmit { saveChange() }
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
                .padding(.horizontal)

                // MARK: - 단수 체크 섹션
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 6) {
                        Image(systemName: "number.square.fill")
                            .foregroundColor(.accentColor)
                        Text("단수 체크")
                            .font(.headline)
                    }
                    .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach($project.rowCounters) { $counter in
                                RowCounterView(
                                    title: $counter.title,
                                    count: $counter.currentRow,
                                    canDelete: project.rowCounters.count > 1,
                                    onChange: {
                                        saveChange()
                                    },
                                    onDelete: {
                                        deleteCounter(counter)
                                    }
                                )
                            }

                            // ➕ 단수 추가 카드
                            Button {
                                addCounter()
                            } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 32))
                                        .foregroundColor(.accentColor)
                                    Text("단수 추가")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .frame(width: 140, height: 150)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(
                                            Color.accentColor.opacity(0.3),
                                            style: StrokeStyle(lineWidth: 2, dash: [6])
                                        )
                                )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                    }
                }

                // MARK: - 메모 섹션
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 6) {
                        Image(systemName: "note.text")
                            .foregroundColor(.accentColor)
                        Text("메모")
                            .font(.headline)
                    }

                    ZStack(alignment: .topLeading) {
                        if project.notes.isEmpty {
                            Text("메모를 입력하세요...")
                                .foregroundColor(Color(.systemGray3))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 12)
                        }
                        TextEditor(text: $project.notes)
                            .frame(minHeight: 120)
                            .scrollContentBackground(.hidden)
                            .padding(6)
                    }
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage)
        }
        .onChange(of: selectedImage) { newImage in
            if let img = newImage {
                if let data = img.jpegData(compressionQuality: 0.1) {
                    project.photoData = data
                    saveChange()
                }
            }
        }
        .alert("사진을 삭제할까요?", isPresented: $showDeleteAlert) {
            Button("삭제", role: .destructive) {
                project.photoData = nil
                saveChange()
            }
            Button("취소", role: .cancel) {}
        }
        .onDisappear {
            selectedTab = 0
            store.save()
        }
    }

    private func saveChange() {
        store.update(project)
    }

    private func deleteCounter(_ counter: RowCounter) {
        project.rowCounters.removeAll { $0.id == counter.id }
        saveChange()
    }

    private func addCounter() {
        let index = project.rowCounters.count + 1
        let newCounter = RowCounter(
            title: "단수 \(index)",
            currentRow: 0
        )
        project.rowCounters.append(newCounter)
        saveChange()
    }
}
