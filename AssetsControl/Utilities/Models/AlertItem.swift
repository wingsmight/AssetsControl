//
//  AlertItem.swift
//
//  Created by Igoryok
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()

    var title: Text
    var message: Text?
    var dismissButton: Alert.Button?

    init(title: Text,
         message: Text? = nil,
         dismissButton: Alert.Button? = nil)
    {
        self.title = title
        self.message = message
        self.dismissButton = dismissButton
    }

    init(titleText: String,
         message: Text? = nil,
         dismissButton: Alert.Button? = nil)
    {
        self.init(title: Text(titleText),
                  message: message,
                  dismissButton: dismissButton)
    }
}
