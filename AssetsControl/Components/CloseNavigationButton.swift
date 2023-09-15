//
//  CloseNavigationButton.swift
//
//  Created by Igoryok
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
