//
//  ProjectStore.swift
//  KnittingNote
//
//  Created by 문혜경 on 11/12/25.
//

import Foundation
@MainActor
class ProjectStore: ObservableObject{
    @Published var projects: [KnitProject] = []
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
            if let data = try? JSONEncoder().encode(projects) {
                try? data.write(to: savePath)
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
