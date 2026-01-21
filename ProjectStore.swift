//
//  ProjectStore.swift
//  KnittingNote
//
//  Created by 문혜경 on 11/12/25.
//

import Foundation
@MainActor
class ProjectStore: ObservableObject{
    @Published var projects: [KnitProject] = [] {
            didSet {
                save()
            }
        }
        private let savePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("projects.json")
        
        init() {
            load()
        }
        
        func load() {
            guard let data = try? Data(contentsOf: savePath) else { return }
            if let decoded = try? JSONDecoder().decode([KnitProject].self, from: data) {
                projects = decoded
            }
        }
        
    func save() {
        // 1. 현재 데이터를 '값'으로 복사 (메인 스레드 점유 최소화)
        let projectsCopy = self.projects
        let path = self.savePath

        // 2. Task에서 'detached'를 사용해 메인 액터와 완전히 격리시킵니다.
        Task.detached(priority: .background) {
            do {
                // 3. 사진이 든 무거운 데이터를 JSON으로 바꾸는 고된 작업 (백그라운드)
                let data = try JSONEncoder().encode(projectsCopy)
                // 4. 파일 쓰기
                try data.write(to: path)
                print("✅ 백그라운드 저장 성공")
            } catch {
                print("❌ 저장 오류: \(error)")
            }
        }
    }
        
        func add(_ project: KnitProject) {
            projects.append(project)
            save()
        }
        
        func update(_ project: KnitProject) {
            if let index = projects.firstIndex(where: { $0.id == project.id }) {
                projects[index] = project
                save()
            }
        }
        
        func delete(_ indexSet: IndexSet) {
            projects.remove(atOffsets: indexSet)
            save()
        }
    
    
}
