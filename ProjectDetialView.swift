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
                
                
                Text("단수 체크")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach($project.rowCounters) { $counter in
                            RowCounterView(
                                title: $counter.title,
                                count: $counter.currentRow,
                                canDelete: project.rowCounters.count > 1,   //한개일때는 삭제 못하게
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
                                    .font(.system(size: 36))
                                    .foregroundColor(.accentColor)

                                Text("단수 추가")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .frame(width: 170, height: 170)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .strokeBorder(
                                        Color.accentColor.opacity(0.4),
                                        style: StrokeStyle(lineWidth: 2, dash: [6])
                                    )
                            )
                        }
                        
                    }
                    .padding(.vertical, 4)
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
