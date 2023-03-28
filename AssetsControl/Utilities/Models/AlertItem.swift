//
//  AlertItem.swift
//  Splus
//
//  Created by Igoryok on 03.03.2023.
//

import SwiftUI

struct AlertItem: Identifiable {
    var id = UUID()
    var title: Text
    var message: Text?
    var dismissButton: Alert.Button?

    init(id: UUID = UUID(),
         title: Text,
         message: Text? = nil,
         dismissButton: Alert.Button? = nil)
    {
        self.id = id
        self.title = title
        self.message = message
        self.dismissButton = dismissButton
    }

    init(id: UUID = UUID(),
         titleText: String,
         message: Text? = nil,
         dismissButton: Alert.Button? = nil)
    {
        self.init(id: id,
                  title: Text(titleText),
                  message: message,
                  dismissButton: dismissButton)
    }
}
