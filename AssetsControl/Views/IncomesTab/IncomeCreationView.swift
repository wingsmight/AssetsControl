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
    @State private var source: IncomeSource = .init(name: "default", currency: .dollar)
    @State private var moneyHolderTarget: MoneyHolder = .init(name: "default")
    @State private var date: Date = Date()

    @EnvironmentObject private var financesStore: FinancialDataStore

    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    init(income: Binding<(any Income)?>,
         isShowing: Binding<Bool>)
    {
        _income = income
        _isShowing = isShowing

        if let incomeSource = income.wrappedValue?.source {
            source = incomeSource
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    nameField

                    currencyField

                    sourcePicker
                }

                Section {
                    moneyHolderPicker
                }

                Section {
                    DatePicker("Date", selection: $date)
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
                                                  initialDate: date,
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
        .onAppear {
            if let incomeSource = financesStore.data.incomeSources.first {
                source = incomeSource
            }
        }
    }

    private var nameField: some View {
        TextField("Name", text: $name)
            .autocapitalization(.words)
    }

    private var currencyField: some View {
        HStack {
            MoneyCountField("Money amount", value: $amount)

            Text(source.currency.symbol)
        }
    }

    private var sourcePicker: some View {
        SourcePicker(incomeSources: financesStore.data.incomeSources, selected: $source)
    }

    private var moneyHolderPicker: some View {
        MoneyHolderTargetPickerRow(selectedMoneyHolder: $moneyHolderTarget,
                                   moneyHolders: financesStore.data.moneyHolders)
    }

    private var symbolPicker: some View {
        SymbolPicker(selected: $symbol)
    }

    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
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

struct SourcePicker: View {
    let incomeSources: [IncomeSource]

    @Binding var selected: IncomeSource

    var body: some View {
        if incomeSources.isEmpty {
            Text("empty")
        } else {
            Picker("Source", selection: $selected) {
                ForEach(incomeSources, id: \.self) { incomeSource in
                    Label("\(incomeSource.name) \(incomeSource.currency.symbol)",
                          systemImage: incomeSource.symbol.systemImageName)
                }
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
