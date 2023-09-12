//
//  IncomeCreationView.swift
//  AssetsControl
//
//  Created by Igoryok on 08.09.2023.
//

import SwiftUI

struct IncomeCreationView: View {
    @Binding private var income: (any Income)?
    @Binding private var isShowing: Bool

    @State private var name: String = ""
    @State private var symbol: Symbol = .defaultSymbol
    @State private var amount: Double?
    @State private var source: IncomeSource = .init(name: "default")
    @State private var moneyHolderTarget: MoneyHolder = .init(name: "default")

    @EnvironmentObject private var financesStore: FinancialDataStore

    init(income: Binding<(any Income)?>,
         isShowing: Binding<Bool>)
    {
        _income = income
        _isShowing = isShowing
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    nameField

                    currencyField
                }

                Section {
                    moneyHolderPicker
                }

                Section {
                    symbolPicker
                }
            }
            .navigationTitle("Add Income")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        income = nil
                        
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        if let amount {
                            income = ActiveIncome(name: name,
                                                  symbol: symbol,
                                                  source: source,
                                                  target: moneyHolderTarget,
                                                  amount: Money(amount))

                            dismiss()
                        }
                    }
                    .disabled(isDoneButtonDisabled)
                }
            }
        }
        .onAppear {
            guard let firstMoneyHolder = financesStore.data.moneyHolders.first else { return }

            moneyHolderTarget = firstMoneyHolder
        }
    }

    private var nameField: some View {
        TextField("Name", text: $name)
            .autocapitalization(.words)
    }

    private var currencyField: some View {
        CurrencyField("Money amount",
                      value: $amount)
    }

    private var moneyHolderPicker: some View {
        MoneyHolderTargetPickerRow(selectedMoneyHolder: $moneyHolderTarget,
                                   moneyHolders: financesStore.data.moneyHolders)
    }

    private var symbolPicker: some View {
        SymbolPicker(selected: $symbol)
    }

    private func dismiss() {
        isShowing = false
    }

    private var isDoneButtonDisabled: Bool {
        amount == nil
    }
}

struct MoneyHolderTargetPickerRow: View {
    @Binding var selectedMoneyHolder: MoneyHolder

    var moneyHolders: [MoneyHolder]

    var body: some View {
        Picker("Target", selection: $selectedMoneyHolder) {
            ForEach(moneyHolders, id: \.self) { moneyHolder in
                Label(moneyHolder.name, systemImage: moneyHolder.symbol.systemImageName)
                    .tag(moneyHolder.id)
            }
        }
    }
}

struct IncomeCreationView_Previews: PreviewProvider {
    @StateObject private static var financialDataStore = FinancialDataStore()

    static var previews: some View {
        IncomeCreationView(income: .constant(nil),
                           isShowing: .constant(false))
            .environmentObject(financialDataStore)
    }
}
