//
//  MultilineTextField.swift
//  Splus
//
//  Created by Igoryok on 30.01.2023.
//

import Foundation
import SwiftUI

struct MultilineTextField_iOS15: View {
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
