//
//  ExpenseCreationView.swift
//  AssetsControl
//
//  Created by Igoryok on 28.03.2023.
//

import SwiftUI

struct ExpenseCreationView: View {
    @Binding private var expense: Expense?
    @Binding private var isShowing: Bool

    @State private var name: String = ""
    @State private var selectedSymbol: Symbol = .defaultSymbol
    @State private var moneyAmount: Double?
    @State private var moneyCurrency: Currency = .dollar
    @State private var moneyHolderSource: MoneyHolder = .init(name: "default")

    @EnvironmentObject private var financesStore: FinancialDataStore

    init(expense: Binding<Expense?>,
         isShowing: Binding<Bool>)
    {
        _expense = expense
        _isShowing = isShowing
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    nameField

                    moneyField
                }

                Section {
                    moneyHolderPicker
                }

                Section {
                    symbolPicker
                }
            }
            .navigationTitle("Add Expense")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        expense = nil

                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        if let moneyAmount {
                            let amount = Money(moneyAmount, of: moneyCurrency)

                            expense = Expense(name: name,
                                              symbol: selectedSymbol,
                                              amount: amount,
                                              moneyHolderSource: moneyHolderSource)

                            dismiss()
                        }
                    }
                    .disabled(isDoneButtonDisabled)
                }
            }
        }
        .onAppear {
            guard let firstMoneyHolder = financesStore.data.moneyHolders.first else { return }

            moneyHolderSource = firstMoneyHolder

            moneyCurrency = firstMoneyHolder.initialMoney.currency
        }
        .onChange(of: moneyHolderSource) { newSelectedMoneyHolderSource in
            moneyCurrency = newSelectedMoneyHolderSource.initialMoney.currency
        }
    }

    private var nameField: some View {
        TextField("Name", text: $name)
            .autocapitalization(.words)
    }

    private var moneyField: some View {
        HStack {
            MoneyCountField("Money amount", value: $moneyAmount)

            Text(moneyCurrency.symbol)
        }
    }

    private var moneyHolderPicker: some View {
        MoneyHolderPicker(selected: $moneyHolderSource,
                          moneyHolders: financesStore.data.moneyHolders)
    }

    private var symbolPicker: some View {
        SymbolPicker(selected: $selectedSymbol)
    }

    private func dismiss() {
        isShowing = false
    }

    private var isDoneButtonDisabled: Bool {
        moneyAmount == nil
    }
}

struct AssetCreationView_Previews: PreviewProvider {
    @StateObject private static var financialDataStore = FinancialDataStore()

    static var previews: some View {
        ExpenseCreationView(expense: .constant(nil),
                            isShowing: .constant(false))
            .environmentObject(financialDataStore)
    }
}
