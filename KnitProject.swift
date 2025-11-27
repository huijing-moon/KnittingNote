//
//  KnitProject.swift
//  KnittingNote
//
//  Created by 문혜경 on 11/12/25.
//

import Foundation
import SwiftUI

enum ProjectStatus: String, Codable, CaseIterable {
    case inProgress = "작업 중"
    case completed = "완성"
    case wishlist = "위시리스트"
    
    
    var displayName: String {
        self.rawValue
    }
}


struct KnitProject: Identifiable, Codable {
    var id = UUID()
    var title: String
    var yarn: String
    var needle: String
    var currentRow: Int = 0
    var notes: String = ""
    var photoData: Data? = nil
    var status: ProjectStatus = .inProgress
}

extension KnitProject {
    var image: Image? {
        if let data = photoData, let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        }
        return nil
    }
}
