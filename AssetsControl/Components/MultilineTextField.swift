//
//  MultilineTextField.swift
//
//  Created by Igoryok
//

import Foundation
import SwiftUI

// swiftlint: disable type_name
struct MultilineTextField_iOS15: View {
// swiftlint: enable type_name
    let internalPadding: CGFloat = 5

    let placeholder: String
    @Binding var text: String

    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color.primary.opacity(0.25))
                    .padding(EdgeInsets(top: 7, leading: 4, bottom: 0, trailing: 0))
                    .padding(internalPadding)
            }
            TextEditor(text: $text)
                .padding(internalPadding)
        }.onAppear {
            UITextView.appearance().backgroundColor = .clear
        }.onDisappear {
            UITextView.appearance().backgroundColor = nil
        }
    }
}

struct MultilineTextField_Previews: PreviewProvider {
    static var previews: some View {
        MultilineTextField_iOS15(placeholder: "placheholder...", text: .constant(""))
    }
}
