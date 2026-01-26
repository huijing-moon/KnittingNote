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
            
                // MARK: - 제목 + 상태 + 정보
                VStack(alignment: .leading, spacing: 12) {
                    Text(project.title)
                        .font(.largeTitle.bold())
                    Picker("상태", selection: $project.status) {
                        ForEach(ProjectStatus.allCases, id: \.self) {
                            Text($0.displayName).tag($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: project.status) { newValue in
                        saveChange()  // ⭐️ 변경 시 즉시 저장
                        selectedTab = 0
                    }
                    
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
                        .allowsHitTesting(false)   // ⭐️ 핵심
                        .allowsHitTesting(false)   // ⭐️ 핵심
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
        .onDisappear {
            selectedTab = 0
            store.save()  // 최종 저장만 수행
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
