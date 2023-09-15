//
//  LargeButtonStyle.swift
//
//  Created by Igoryok
//

import SwiftUI

struct LargeButtonStyle: ButtonStyle {
    let backgroundColor: Color
    let foregroundColor: Color
    let isDisabled: Bool
    let cornerRadius: CGFloat

    init(backgroundColor: Color,
         foregroundColor: Color,
         isDisabled: Bool = false,
         cornerRadius: CGFloat = 6.0)
    {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.isDisabled = isDisabled
        self.cornerRadius = cornerRadius
    }

    func makeBody(configuration: Self.Configuration) -> some View {
        let currentForegroundColor = isDisabled || configuration.isPressed ? foregroundColor.opacity(0.3) : foregroundColor
        return configuration.label
            .padding()
            .foregroundColor(currentForegroundColor)
            .background(isDisabled || configuration.isPressed ? backgroundColor.opacity(0.3) : backgroundColor)
            .cornerRadius(cornerRadius)
            .font(Font.system(size: 19, weight: .semibold))
    }
}

struct LargeButtonStyle_Previews: PreviewProvider {
    private static let backgroundColor = Color(.systemGray3)
    private static let foregroundColor = Color.white
    private static let cornerRadius: CGFloat = 12.0

    static var previews: some View {
        Button {} label: {
            HStack(alignment: .bottom) {
                Text("Title")
                    .font(.title)

                Spacer()

                Text("headline.")
                    .font(.headline)
            }
        }
        .buttonStyle(LargeButtonStyle(backgroundColor: Self.backgroundColor,
                                      foregroundColor: Self.foregroundColor,
                                      cornerRadius: Self.cornerRadius))
    }
}
