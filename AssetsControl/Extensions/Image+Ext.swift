//
//  Image+Ext.swift
//
//  Created by Igoryok
//

import SwiftUI

extension Image {
    init(safeSystemImage: String, default defaultSystemImage: String = "questionmark") {
        let image = UIImage(systemName: safeSystemImage)
        let defaultImage = UIImage(systemName: defaultSystemImage)

        var systemImageName: String
        if image != nil {
            systemImageName = safeSystemImage
        } else if defaultImage != nil {
            systemImageName = defaultSystemImage
        } else {
            systemImageName = ""
        }

        self.init(systemName: systemImageName)
    }
}
