//
//  IncomeSourceCreationView.swift
//  AssetsControl
//
//  Created by Igoryok on 11.10.2023.
//

import SwiftUI

struct IncomeSourceCreationView: View {
    @Binding private var incomeSource: IncomeSource?

    @State private var name: String = ""
    @State private var description: String = ""
    @State private var symbol: Symbol = .defaultSymbol
    @State private var defaultAmount: Double? = nil
    @State private var currency: Currency = .dollar

    @State private var isCurrencyPickerShowing: Bool = false

    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    init(incomeSource: Binding<IncomeSource?>)
    {
        self._incomeSource = incomeSource
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    nameField

                    moneyField
                }

                Section {
                    symbolPicker
                }
            }
            .navigationTitle("New Income Source")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        incomeSource = nil
                        
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        incomeSource = IncomeSource(name: name,
                                                    description: description,
                                                    symbol: symbol,
                                                    defaultAmount: defaultAmount,
                                                    currency: currency)

                        dismiss()
                    }
                    .disabled(isDoneButtonDisabled)
                }
            }
        }
    }

    private var nameField: some View {
        TextField("Name", text: $name)
            .autocapitalization(.words)
    }

    private var moneyField: some View {
        HStack {
            MoneyCountField("Default amount", value: $defaultAmount)

            Button {
                isCurrencyPickerShowing.toggle()
            } label: {
                CurrencyIcon(currency: currency)
            }
            .buttonStyle(BorderlessButtonStyle())
            .background(
                NavigationLink(isActive: $isCurrencyPickerShowing, destination: {
                    VStack {
                        CurrencyPickerScreen(selectedCurrency: $currency)
                    }
                }, label: {
                    EmptyView()
                })
            )
        }
    }

    private var symbolPicker: some View {
        SymbolPicker(selected: $symbol)
    }

    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }

    private var isDoneButtonDisabled: Bool {
        false
    }
}

struct IncomeSourceCreationView_Previews: PreviewProvider {
    static var previews: some View {
        IncomeSourceCreationView(incomeSource: .constant(nil))
    }
}
