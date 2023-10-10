//
//  DecimalField.swift
//
//  Created by Edwin Watkeys on 9/20/19.
//  Copyright © 2019 Edwin Watkeys.
//

import Combine
import SwiftUI

// TODO: filter input
struct OptionalDoubleField: View {
    let label: LocalizedStringKey
    let formatter: NumberFormatter
    let onEditingChanged: (Bool) -> Void
    let onCommit: () -> Void

    // The text shown by the wrapped TextField. This is also the "source of
    // truth" for the `value`.
    @State private var textValue: String = ""

    // When the view loads, `textValue` is not synced with `value`.
    // This flag ensures we don't try to get a `value` out of `textValue`
    // before the view is fully initialized.
    @State private var hasInitialTextValue = false

    @Binding var value: Double?

    init(
        _ label: LocalizedStringKey,
        value: Binding<Double?>,
        formatter: NumberFormatter,
        onEditingChanged: @escaping (Bool) -> Void = { _ in },
        onCommit: @escaping () -> Void = {}
    ) {
        self.label = label
        _value = value
        self.formatter = formatter
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
    }

    var body: some View {
        TextField(label,
                  text: $textValue,
                  onEditingChanged: { isInFocus in
                      // When the field is in focus we replace the field's contents
                      // with a plain unformatted number. When not in focus, the field
                      // is treated as a label and shows the formatted value.
                      if isInFocus {
                          if formatter.numberStyle == .percent, let value {
                              textValue = (value * 100).description
                          } else {
                              textValue = value?.description ?? ""
                          }
                      } else {
                          var newValue = formatter.number(from: textValue)?.doubleValue
                          if newValue == nil {
                              newValue = Double(textValue)
                              if let temp = newValue, formatter.numberStyle == .percent {
                                  newValue = temp / 100
                              }
                          }
                          textValue = formatter.string(for: newValue) ?? ""
                      }
                      onEditingChanged(isInFocus)
                  },
                  onCommit: onCommit)
            .onChange(of: textValue) {
                guard hasInitialTextValue else {
                    // We don't have a usable `textValue` yet -- bail out.
                    return
                }

//                textValue = textValue
//                    .removingExceptFirst(".")
//                    .removingExceptFirst(",")
//                    .removingLeadingZero()

//                textValue = String(format: "%.2f", textValue)

//                textValue = formatCurrency(textValue)

                // This is the only place we update `value`.
                value = formatter.number(from: $0)?.doubleValue
                if value == nil {
                    value = Double($0)
                    if let temp = value, formatter.numberStyle == .percent {
                        value = temp / 100
                    }
                }
            }
            .onAppear { // Otherwise textfield is empty when view appears
                hasInitialTextValue = true
                // Any `textValue` from this point on is considered valid and
                // should be synced with `value`.
                if let value {
                    // Synchronize `textValue` with `value`; can't be done earlier
                    textValue = formatter.string(from: NSDecimalNumber(value: value)) ?? ""
                    // TODO: .replacingOccurrences(of: ",", with: ".")
                }
            }
            .keyboardType(.decimalPad)
    }
}

func formatCurrency(_ value: String) -> String {
    guard let doubleValue = Double(value) else { return "0.00" }
    let formattedValue = String(format: "%.2f", doubleValue)
    return formattedValue
}

struct OptionalDoubleField_Previews: PreviewProvider {
    static var previews: some View {
        OptionalDoubleField("Title", value: .constant(0.0), formatter: NumberFormatter())
    }
}
