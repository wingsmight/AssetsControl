//
//  RoundedTextFieldStyle.swift
//
//  Created by Igoryok
//

import SwiftUI

struct RoundedTextFieldStyle: TextFieldStyle {
    let backgroundColor: Color
    let foregroundColor: Color?
    let cornerRadius: CGFloat

    init(backgroundColor: Color,
         foregroundColor: Color? = nil,
         cornerRadius: CGFloat = 6.0)
    {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.cornerRadius = cornerRadius
    }

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
    }
}
