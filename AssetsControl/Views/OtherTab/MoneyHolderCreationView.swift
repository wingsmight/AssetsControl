//
//  MoneyHolderCreationView.swift
//  AssetsControl
//
//  Created by Igoryok on 07.04.2023.
//

import SwiftUI

struct MoneyHolderCreationView: View {
    @Binding var moneyHolder: MoneyHolder?
    @Binding var isShowing: Bool

    @State private var createdMoneyHolder: MoneyHolder = .init(name: "")
    @State private var test: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name", text: $createdMoneyHolder.name)
                        .autocapitalization(.words)

                    TextField("Description", text: $createdMoneyHolder.description)
                        .autocapitalization(.words)

                    CurrencyField("Current Money Count",
                                  value: Binding<Double?>($createdMoneyHolder.initialMoney.count))
                }

                Section {
                    SymbolPicker(selected: $createdMoneyHolder.symbol)
                }
            }
            .navigationTitle("Create Account")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        guard !createdMoneyHolder.name.isEmpty else {
                            moneyHolder = nil
                            dismiss()

                            return
                        }

                        moneyHolder = createdMoneyHolder

                        dismiss()
                    }
                }
            }
            .hideKeyboardWhenTappedAround()
        }
    }

    func dismiss() {
        isShowing = false
    }
}

struct MoneyHolderCreationView_Previews: PreviewProvider {
    static var previews: some View {
        MoneyHolderCreationView(moneyHolder: .constant(MoneyHolder(name: "")),
                                isShowing: .constant(true))
    }
}
