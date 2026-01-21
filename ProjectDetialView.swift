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
    // 1. UI용 로컬 상태를 하나 만듭니다. (초기값은 프로젝트의 현재 상태)
    @State private var selectedStatus: ProjectStatus = .inProgress
    @State private var showDeleteAlert = false
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = nil

 
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
            
                // MARK: - 제목 + 상태 + 정보
                VStack(alignment: .leading, spacing: 12) {
                    Text(project.title)
                        .font(.largeTitle.bold())
                    Picker("상태", selection: $selectedStatus) {
                                            ForEach(ProjectStatus.allCases, id: \.self) { status in
                                                Text(status.displayName).tag(status)
                                            }
                                        }
                                        .pickerStyle(.segmented)
                                        // ✅ 추가: 값이 바뀔 때 UI만 먼저 반응하게 강제합니다.
                                        .onChange(of: selectedStatus) { _ in
                                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                        }
                    .pickerStyle(.segmented)
                    Divider()
                 
                    
                    HStack {
                        Label(project.yarn, systemImage: "scissors")
                        Label(project.needle, systemImage: "paintbrush.pointed" )
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                }
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
                        if let img = newImage {
                            // 압축률을 0.1(최대 압축)로 설정해보세요.
                            // 0.1이어도 폰 화면에서 보기엔 충분합니다.
                            if let data = img.jpegData(compressionQuality: 0.1) {
                                project.photoData = data
                            }
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
                  //  .onChange(of: project.notes) { _ in saveChange() }
               
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
        .onAppear {
                    // 3. 페이지가 열릴 때 딱 한 번만 데이터를 복사해옵니다.
                    if selectedStatus != project.status {
                        selectedStatus = project.status
                    }
                }
                .onDisappear {
                    // 4. 페이지를 완전히 나갈 때만 원본에 '딱 한 번' 저장합니다.
                    // 이렇게 하면 Picker를 누를 때 부모 리스트가 갱신되지 않습니다.
                    if project.status != selectedStatus {
                        project.status = selectedStatus
                        store.update(project) // 직접 store를 호출하여 확실히 저장
                    }
                }
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
