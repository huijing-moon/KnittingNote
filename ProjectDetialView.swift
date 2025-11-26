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
                if let image = project.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 220)
                        .clipped()
                        .cornerRadius(20)
                        .shadow(radius: 5)
                    Button("사진 삭제",role: .destructive) {
                          project.photoData = nil
                          store.save()
                          showDeleteAlert = true
                    }
                      .padding()
                    
                }
                else{
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
                
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(project.title)
                        .font(.largeTitle.bold())
                    HStack {
                        Label(project.yarn, systemImage: "scissors")
                        Label(project.needle, systemImage: "paintbrush.pointed")
                    }
                    .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("현재 단수: \(project.currentRow)")
                            .font(.headline)
                        Spacer()
                        HStack(spacing: 20) {
                            Button {
                                project.currentRow -= 1
                                saveChange()
                            } label: {
                                Image(systemName: "minus.circle.fill")
                            }
                            Button {
                                project.currentRow += 1
                                saveChange()
                            } label: {
                                Image(systemName: "plus.circle.fill")
                            }
                        }
                        .font(.title2)
                        .foregroundColor(.accentColor)
                    }
                    
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
            .padding(.bottom)
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        //실제 삭제 실행
        .alert("사진을 삭제할까요?", isPresented: $showDeleteAlert) {
                    Button("삭제", role: .destructive) {
                        project.photoData = nil
                        store.update(project)   // 저장
                    }
                    Button("취소", role: .cancel) {}
                }
    }
    
    
    private func saveChange() {
        store.update(project)
    }
}
