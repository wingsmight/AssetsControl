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

    @State private var name: String = ""
    @State private var description: String = ""
    @State private var money: Money = Money(0)
    @State private var selectedSymbol: Symbol = .defaultSymbol
    @State private var moneyHolderSource: MoneyHolder = .init(name: "default")

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name", text: $name)
                        .autocapitalization(.words)

                    TextField("Description", text: $description)
                        .autocapitalization(.words)

                    MoneyInputField(initialMoney: $money)
                        .buttonStyle(BorderlessButtonStyle())
                }

                Section {
                    SymbolPicker(selected: $selectedSymbol)
                }
            }
            .navigationTitle("Create Account")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        moneyHolder = nil
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        guard !name.isEmpty else {
                            moneyHolder = nil
                            dismiss()

                            return
                        }

                        moneyHolder = MoneyHolder(name: name,
                                                  description: description,
                                                  symbol: selectedSymbol,
                                                  initialMoney: money,
                                                  initialDate: Date())

                        dismiss()
                    }
                }
            }
            .hideKeyboardWhenTappedAround()
        }
    }

    private func dismiss() {
        isShowing = false
    }
}

struct MoneyHolderCreationView_Previews: PreviewProvider {
    static var previews: some View {
        MoneyHolderCreationView(moneyHolder: .constant(MoneyHolder(name: "")),
                                isShowing: .constant(true))
    }
}
