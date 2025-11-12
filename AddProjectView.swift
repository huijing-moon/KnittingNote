//
//  AddProjectView.swift
//  KnittingNote
//
//  Created by 문혜경 on 11/12/25.
//

import SwiftUI
import PhotosUI

struct AddProjectView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var store: ProjectStore
    
    @State private var title = ""
    @State private var yarn = ""
    @State private var needle = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var photoData: Data?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // 📸 사진 섹션
                    VStack {
                        if let photoData, let uiImage = UIImage(data: photoData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 180)
                                .clipped()
                                .cornerRadius(15)
                                .shadow(radius: 3)
                        } else {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.gray.opacity(0.1))
                                .frame(height: 180)
                                .overlay(
                                    VStack {
                                        Image(systemName: "photo.on.rectangle.angled")
                                            .font(.system(size: 40))
                                            .foregroundColor(.gray)
                                        Text("사진 선택하기")
                                            .foregroundColor(.gray)
                                            .font(.footnote)
                                    }
                                )
                        }
                        
                        PhotosPicker(selection: $selectedPhoto, matching: .images) {
                            Label("사진 추가", systemImage: "plus.circle.fill")
                                .font(.callout)
                                .foregroundColor(.accentColor)
                        }
                    }
                    
                    // 🧶 정보 입력
                    VStack(alignment: .leading, spacing: 16) {
                        InputField(title: "프로젝트 이름", text: $title, icon: "text.book.closed")
                        InputField(title: "실 종류", text: $yarn, icon: "scissors")
                        InputField(title: "바늘", text: $needle, icon: "paintbrush.pointed")
                    }
                    .padding(.horizontal)
                    
                    // ✅ 저장 버튼
                    Button {
                        let newProject = KnitProject(
                            title: title,
                            yarn: yarn,
                            needle: needle,
                            photoData: photoData
                        )
                        store.add(newProject)
                        dismiss()
                    } label: {
                        Text("저장하기")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(title.isEmpty ? Color.gray : Color.accentColor)
                            .cornerRadius(12)
                            .shadow(radius: 3)
                    }
                    .disabled(title.isEmpty)
                    .padding(.horizontal)
                }
                .padding()
            }
            .navigationTitle("새 프로젝트")
            .onChange(of: selectedPhoto) { newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self) {
                        photoData = data
                    }
                }
            }
        }
    }
}

struct InputField: View {
    var title: String
    @Binding var text: String
    var icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
            TextField(title, text: $text)
                .textFieldStyle(.plain)
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}
