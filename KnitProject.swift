//
//  KnitProject.swift
//  KnittingNote
//
//  Created by 문혜경 on 11/12/25.
//

import Foundation
import SwiftUI

struct KnitProject: Identifiable, Codable {
    var id = UUID()
    var title: String
    var yarn: String
    var needle: String
    var currentRow: Int = 0
    var notes: String = ""
    var photoData: Data? = nil
}

extension KnitProject {
    var image: Image? {
        if let data = photoData, let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        }
        return nil
    }
}
