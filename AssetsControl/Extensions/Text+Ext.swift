//
//  Text+Ext.swift
//
//  Created by Igoryok
//

import SwiftUI

extension Text {
    func autoSize(minimumScaleFactor: CGFloat = 0.01) -> some View {
        lineLimit(1)
            .minimumScaleFactor(minimumScaleFactor)
    }
}
