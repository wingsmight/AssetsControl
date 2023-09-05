//
//  AssetCreationView.swift
//  AssetsControl
//
//  Created by Igoryok on 28.03.2023.
//

import SwiftUI

struct AssetCreationView: View {
    @Binding private var expense: Expense?
    @Binding private var isShowing: Bool

    @State private var name: String = ""
    @State private var selectedSymbol: Symbol = .defaultSymbol
    @State private var cost: Double?
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

                    currencyField
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
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        if let cost {
                            expense = Expense(name: name, symbol: selectedSymbol, monthlyCost: cost, moneyHolderSource: moneyHolderSource)

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
        }
    }
    
    private var nameField: some View {
        TextField("Name", text: $name)
            .autocapitalization(.words)
    }
    
    private var currencyField: some View {
        CurrencyField("Money amount",
                      value: $cost)
    }
    
    private var moneyHolderPicker: some View {
        MoneyHolderSourcePickerRow(selectedMoneyHolder: $moneyHolderSource,
                                   moneyHolders: financesStore.data.moneyHolders)
    }
    
    private var symbolPicker: some View {
        SymbolPicker(selected: $selectedSymbol)
    }

    private func dismiss() {
        isShowing = false
    }

    private var isDoneButtonDisabled: Bool {
        cost == nil
    }
}

struct MoneyHolderSourcePickerRow: View {
    @Binding var selectedMoneyHolder: MoneyHolder

    var moneyHolders: [MoneyHolder]

    var body: some View {
        Picker("Source", selection: $selectedMoneyHolder) {
            ForEach(moneyHolders, id: \.self) { moneyHolder in
                Label(moneyHolder.name, systemImage: moneyHolder.symbol.systemImageName)
                    .tag(moneyHolder.id)
            }
        }
    }
}

struct AssetCreationView_Previews: PreviewProvider {
    @StateObject private static var financialDataStore = FinancialDataStore()

    static var previews: some View {
        AssetCreationView(expense: .constant(nil),
                          isShowing: .constant(false))
            .environmentObject(financialDataStore)
    }
}
