//
//  CurrencyPicker.swift
//
//  Created by Igoryok
//

import SwiftUI

struct CurrencyPicker: View {
    private static let backgroundColor = Color(.systemGray3)
    private static let foregroundColor = Color.white
    private static let cornerRadius: CGFloat = 12.0

    private static let searchTextFieldBackgroundColor = Color(.systemGray4)

    private let currencies: [Currency]
    private let preloadedCurrencies: [Currency] = [.dollar, .euro]
    private let onDismiss: (() -> Void)?

    @Binding var selected: Currency

    @State private var inputtedCurrencyText: String = ""

    init(currencies: [Currency] = Currency.allCases,
         selected: Binding<Currency>,
         onDismiss: (() -> Void)? = nil)
    {
        self.currencies = currencies
        self.onDismiss = onDismiss
        _selected = selected
        inputtedCurrencyText = inputtedCurrencyText
    }

    var body: some View {
        VStack {
            searchTextField

            list
        }
    }

    var searchTextField: some View {
        ZStack {
            TextField("Currency", text: $inputtedCurrencyText)
                .textFieldStyle(RoundedTextFieldStyle(backgroundColor: Self.searchTextFieldBackgroundColor))
                .foregroundColor(.green)

            HStack {
                Spacer()

                Button {
                    inputtedCurrencyText = ""

                    onDismiss?()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color(UIColor.quaternaryLabel))
                        .frame(CGSize(squareSize: 18))
                }
                .hidden(inputtedCurrencyText.isEmpty)
                .padding()
            }
        }
    }

    var list: some View {
        ScrollView {
            LazyVStack {
                if inputtedCurrencyText.isEmpty, selected == .none {
                    ForEachWithIndex(preloadedCurrencies) { index, preloadedCurrency in
                        Button {
                            selected = preloadedCurrency
                            inputtedCurrencyText = ""
                        } label: {
                            CurrencyView(currency: preloadedCurrency)
                                .frame(height: 22)
                        }
                        .buttonStyle(LargeButtonStyle(backgroundColor: Self.backgroundColor.opacity(index.isOdd ? 0.8 : 1.0),
                                                      foregroundColor: Self.foregroundColor,
                                                      cornerRadius: Self.cornerRadius))
                        .padding(.vertical, 1)
                    }
                } else if selected != .none {
                    ForEachWithIndex(currencies) { index, currency in
                        if currency.description.starts(with: inputtedCurrencyText.capitalizedSentence) ||
                            currency.description.contains(inputtedCurrencyText.capitalizedSentence) ||
                            currency.symbol.starts(with: inputtedCurrencyText.capitalizedSentence) ||
                            currency.rawValue.starts(with: inputtedCurrencyText.uppercased())
                        {
                            Button {
                                selected = currency
                                inputtedCurrencyText = ""
                            } label: {
                                CurrencyView(currency: currency)
                                    .frame(height: 22)
                            }
                            .buttonStyle(LargeButtonStyle(backgroundColor: Self.backgroundColor.opacity(index.isOdd ? 0.8 : 1.0),
                                                          foregroundColor: Self.foregroundColor,
                                                          cornerRadius: Self.cornerRadius))
                            .padding(.vertical, 1)
                        }
                    }
                }
            }
        }
    }
}

struct CurrencyPicker_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyPickerView()
    }

    private struct CurrencyPickerView: View {
        @State private var selectedCurrency = Currency.none

        var body: some View {
            VStack {
                BankrollView(currency: selectedCurrency)
                    .frame(CGSize(width: 200, height: 100))
                    .background(Color.green)

                CurrencyPicker(selected: $selectedCurrency)
            }
        }
    }
}
