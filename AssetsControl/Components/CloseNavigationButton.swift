//
//  CloseNavigationButton.swift
//  EnglishApp
//
//  Created by Igoryok on 30.05.2022.
//

import SwiftUI

struct CloseNavigationButton: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    
    var body: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.title)
                .padding()
        }
        .buttonStyle(.plain)
    }
}

struct CloseNavigationButton_Previews: PreviewProvider {
    static var previews: some View {
        CloseNavigationButton()
    }
}
