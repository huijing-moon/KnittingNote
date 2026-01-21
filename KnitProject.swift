//
//  KnitProject.swift
//  KnittingNote
//
//  Created by 문혜경 on 11/12/25.
//

import Foundation
import SwiftUI
import UIKit


enum ProjectStatus: String, Codable, CaseIterable, Hashable {
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
    
    // 추가
    var rowTitle: String = "현재 단수"
    
    
    // 🔥 단수 카운터 여러 개
     var rowCounters: [RowCounter] = [
         RowCounter(title: "몸통 단"),
         RowCounter(title: "소매 단")
     ]
}


//단수 카운터 추가
struct RowCounter: Identifiable, Codable {
    var id = UUID()
    var title: String      // 예: 몸통 단, 소매 단
    var currentRow: Int = 0
}

extension KnitProject {
    var rowSummaryText: String {
        rowCounters
            .prefix(3)   // 최대 3개까지만
            .map { "\($0.title) \($0.currentRow)" }
            .joined(separator: " · ")
    }
    
    var image: Image? {
          guard let data = photoData,
                let uiImage = UIImage(data: data) else {
              return nil
          }
          return Image(uiImage: uiImage)
      }
}
