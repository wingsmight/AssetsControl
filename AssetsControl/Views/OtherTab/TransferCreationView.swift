//
//  TransferCreationView.swift
//  AssetsControl
//
//  Created by Igoryok on 13.10.2023.
//

import SwiftUI

struct TransferCreationView: View {
    private static let defaultMoneyHolder: MoneyHolder = .init(name: "default")

    @Binding var transfer: Transfer?

    @State private var id: UUID? = nil
    @State private var sourceMoneyHolder: MoneyHolder = Self.defaultMoneyHolder
    @State private var targetMoneyHolder: MoneyHolder = Self.defaultMoneyHolder
    @State private var description: String = ""
    @State private var moneyAmount: Double? = nil
    @State private var moneyReceivedAmount: Double? = nil
    @State private var moneyCurrency: Currency = .none
    @State private var moneyReceivedCurrency: Currency = .none
    @State private var date: Date = .init()

    @EnvironmentObject private var financesStore: FinancialDataStore

    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Description", text: $description)
                        .autocapitalization(.words)

                    moneyAmountInputField

                    if sourceMoneyHolder.initialMoney.currency != targetMoneyHolder.initialMoney.currency {
                        moneyReceivedAmountInputField
                    }
                }

                Section {
                    DatePicker("Date", selection: $date)
                }

                Section {
                    sourceMoneyHolderPicker
                }

                Section {
                    targetMoneyHolderPicker
                }
            }
            .navigationTitle("New Transfer")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        transfer = nil
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        guard let moneyAmount else { return }

                        transfer = Transfer(source: sourceMoneyHolder,
                                            target: targetMoneyHolder,
                                            description: description,
                                            amount: moneyAmount,
                                            date: date)

                        dismiss()
                    }
                    .disabled(isDoneButtonDisabled)
                }
            }
        }
        .onAppear {
            if let transfer {
                id = transfer.id
                sourceMoneyHolder = transfer.source
                targetMoneyHolder = transfer.target
                description = transfer.description ?? ""
                moneyAmount = transfer.amount
                date = transfer.date
            }
        }
        .onAppear {
            guard let firstMoneyHolder = financesStore.data.moneyHolders.first else { return }

            guard let secondMoneyHolder = financesStore.data.moneyHolders[safe: 1] else { return }

            sourceMoneyHolder = firstMoneyHolder
            targetMoneyHolder = secondMoneyHolder

            moneyCurrency = sourceMoneyHolder.initialMoney.currency
            moneyReceivedCurrency = targetMoneyHolder.initialMoney.currency
        }
        .onChange(of: sourceMoneyHolder) { newSourceMoney in
            moneyCurrency = newSourceMoney.initialMoney.currency
        }
        .onChange(of: targetMoneyHolder) { newTargetMoney in
            moneyReceivedCurrency = newTargetMoney.initialMoney.currency
        }
    }

    private var moneyAmountInputField: some View {
        HStack {
            MoneyCountField("Money amount", value: $moneyAmount)

            Text(moneyCurrency.symbol)
        }
    }
    
    private var moneyReceivedAmountInputField: some View {
        HStack {
            MoneyCountField("Money received amount", value: $moneyReceivedAmount)
            
            Text(moneyReceivedCurrency.symbol)
        }
    }

    private var sourceMoneyHolderPicker: some View {
        MoneyHolderPicker(label: "Source",
                          selected: $sourceMoneyHolder,
                          moneyHolders: financesStore.data.moneyHolders)
    }

    private var targetMoneyHolderPicker: some View {
        MoneyHolderPicker(label: "Target",
                          selected: $targetMoneyHolder,
                          moneyHolders: financesStore.data.moneyHolders)
    }

    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }

    private var isDoneButtonDisabled: Bool {
        moneyAmount == nil
    }
}

struct TransferCreationView_Previews: PreviewProvider {
    static var previews: some View {
        TransferCreationView(transfer: .constant(nil))
    }
}
