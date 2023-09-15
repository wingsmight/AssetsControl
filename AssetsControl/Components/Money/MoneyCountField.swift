//
//  MoneyCountField.swift
//
//  Created by Igoryok
//

import Combine
import Foundation
import SwiftUI

struct MoneyCountField: View {
    private let label: LocalizedStringKey
    private let onEditingChanged: (Bool) -> Void
    private let onCommit: () -> Void

    @Binding private var value: Double?

    @State private var textValue: String = ""

    init(_ label: LocalizedStringKey = "",
         value: Binding<Double?>,
         onEditingChanged: @escaping (Bool) -> Void = { _ in },
         onCommit: @escaping () -> Void = {})
    {
        self.label = label
        _value = value
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
    }

    var body: some View {
        TextField(label,
                  text: $textValue,
                  onEditingChanged: { isBeginEditing in
                      if !isBeginEditing {
                          value = Double(textValue)
                      }

                      onEditingChanged(isBeginEditing)
                  },
                  onCommit: onCommit)
            .onReceive(Just(textValue)) { newValue in
                textValue = newValue.filter { Set("0123456789,.").contains($0) }

                textValue = textValue
                    .replacingOccurrences(of: ",", with: ".")
                    .removingExceptFirst(".")

                textValue = format(textValue)
            }
            .keyboardType(.decimalPad)
    }

    private func format(_ textString: String) -> String {
        guard let text0 = textString.components(separatedBy: ".")[safe: 0] else {
            return textString
        }
        guard let text1 = textString.components(separatedBy: ".")[safe: 1] else {
            return text0
        }

        return "\(text0).\(text1.prefix(2))"
    }
}

struct CurrencyField_Previews: PreviewProvider {
    static var previews: some View {
        MoneyCountField("Title",
                        value: .constant(0.0))
    }
}
