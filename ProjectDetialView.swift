//
//  ProjectDetialView.swift
//  KnittingNote
//
//  Created by 문혜경 on 11/12/25.
//

import SwiftUI

struct ProjectDetailView: View {
    @EnvironmentObject var store: ProjectStore
    @State var project: KnitProject
    @State private var showDeleteAlert = false
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // MARK: - 사진 영역
                if let image = project.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 220)
                        .clipped()
                        .cornerRadius(20)
                        .shadow(radius: 5)

                    Button("사진 삭제", role: .destructive) {
                        showDeleteAlert = true
                    }
                    .padding()

                } else {
                    Button("사진 추가") {
                        showImagePicker = true
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(image: $selectedImage)
                    }
                    .onChange(of: selectedImage) { newImage in
                        if let img = newImage,
                           let data = img.jpegData(compressionQuality: 0.8) {
                            var updated = project
                            updated.photoData = data
                            store.update(updated)
                        }
                    }
                }

                // MARK: - 제목 + 상태 + 정보
                VStack(alignment: .leading, spacing: 12) {
                    Text(project.title)
                        .font(.largeTitle.bold())

                    Picker("상태", selection: $project.status) {
                        ForEach(ProjectStatus.allCases, id: \.self) { status in
                            Text(status.displayName).tag(status)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: project.status) { _ in saveChange() }

                    Divider()

                    HStack {
                        Label(project.yarn, systemImage: "scissors")
                        Label(project.needle, systemImage: "paintbrush.pointed")
                    }
                    .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

                // MARK: - 단수 카운터
                VStack(spacing: 16) {
                    Text("현재 단수")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    ZStack {
                        Circle()
                            .fill(Color(.systemGray6))
                            .frame(width: 140, height: 140)
                            .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 4)

                        Text("\(project.currentRow)")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.accentColor)
                    }

                    HStack(spacing: 40) {
                        Button {
                            if project.currentRow > 0 {
                                project.currentRow -= 1
                                saveChange()
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .font(.system(size: 42))
                                .foregroundColor(.red.opacity(0.8))
                                .shadow(radius: 3)
                        }

                        Button {
                            project.currentRow += 1
                            saveChange()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 42))
                                .foregroundColor(.green.opacity(0.8))
                                .shadow(radius: 3)
                        }
                    }
                }

                // MARK: - 메모 입력
                TextEditor(text: $project.notes)
                    .frame(height: 150)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .onChange(of: project.notes) { _ in saveChange() }

            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.05), radius: 4)
            .padding(.horizontal)
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .padding(.bottom)
        .alert("사진을 삭제할까요?", isPresented: $showDeleteAlert) {
            Button("삭제", role: .destructive) {
                project.photoData = nil
                saveChange()
            }
            Button("취소", role: .cancel) {}
        }
    }

    private func saveChange() {
        store.update(project)
    }
}
