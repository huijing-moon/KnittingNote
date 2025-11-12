//
//  KnittingNoteApp.swift
//  KnittingNote
//
//  Created by 문혜경 on 11/12/25.
//

import SwiftUI

@main
struct KnitNoteApp: App {
    @StateObject private var store = ProjectStore()
    
    var body: some Scene {
        WindowGroup {
            ProjectListView()
                .environmentObject(store)
        }
    }
}
