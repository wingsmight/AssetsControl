//
//  SmallCurrencyPicker.swift
//
//  Created by Igoryok
//

import SwiftUI

struct SmallCurrencyPicker: View {
    let label: String = ""
    let currencies: [Currency]

    @Binding var selected: Currency

    var body: some View {
        Picker(label, selection: $selected) {
            ForEach(currencies, id: \.self) { currency in
                Text(currency.symbol)
                    .tag(currency.id)
            }
        }
    }
}

struct SmallCurrencyPicker_Previews: PreviewProvider {
    static var previews: some View {
        SmallCurrencyPickerView()
    }

    private struct SmallCurrencyPickerView: View {
        let currencies: [Currency] = [.dollar, .russianRuble, .tenge]

        @State private var selectedCurrency = Currency.dollar

        var body: some View {
            VStack {
                Text(selectedCurrency.description)

                SmallCurrencyPicker(currencies: currencies,
                                    selected: $selectedCurrency)
            }
        }
    }
}
