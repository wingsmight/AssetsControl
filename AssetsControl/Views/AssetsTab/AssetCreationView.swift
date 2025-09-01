//
//  AssetCreationView.swift
//  AssetsControl
//
//  Created by Igoryok
//

import SwiftUI

struct AssetCreationView: View {
    @Binding private var asset: Asset?
    @Binding private var isShowing: Bool

    @State private var name: String = ""
    @State private var selectedSymbol: Symbol = .stocks
    @State private var moneyAmount: Double?
    @State private var moneyCurrency: Currency = .dollar
    @State private var moneyHolderSource: MoneyHolder = .init(name: "default")
    @State private var date: Date = .init()

    @EnvironmentObject private var financesStore: FinancialDataStore
    @EnvironmentObject private var preferencesDataStore: PreferencesDataStore
    @EnvironmentObject private var userDataStore: UserDataStore

    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    init(asset: Binding<Asset?>,
         isShowing: Binding<Bool>)
    {
        _asset = asset
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
                    DatePicker("Date", selection: $date)
                }

                Section {
                    symbolPicker
                }
            }
            .navigationTitle("Add Asset")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        asset = nil

                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        if let moneyAmount {
                            let amount = Money(moneyAmount, of: moneyCurrency)

                            asset = Asset(name: name,
                                          symbol: selectedSymbol,
                                          amount: amount,
                                          moneyHolderSource: moneyHolderSource,
                                          date: date)

                            dismiss()
                        }
                    }
                    .disabled(isDoneButtonDisabled)
                }
            }
        }
        .onAppear {
            guard let firstMoneyHolder = financesStore.data.moneyHolders.first else { return }

            moneyHolderSource = getDefaultMoneyHolderSource()

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
        presentationMode.wrappedValue.dismiss()
    }

    // TODO: refactor to separate class (DI)
    private func getDefaultMoneyHolderSource() -> MoneyHolder {
        switch preferencesDataStore.data.defaultMoneyHolderSourceMethod {
        case let .selected(moneyHolder):
            return moneyHolder ?? MoneyHolder.test
        case .ai, .lastUsed:
            let firstMoneyHolder = financesStore.data.moneyHolders.first
            return userDataStore.data.lastMoneyHolderSource ?? firstMoneyHolder ?? MoneyHolder.test
        }
    }

    private var isDoneButtonDisabled: Bool {
        moneyAmount == nil
    }
}

struct AssetCreationView_Previews: PreviewProvider {
    @StateObject private static var financialDataStore = FinancialDataStore()

    static var previews: some View {
        AssetCreationView(asset: .constant(nil),
                          isShowing: .constant(false))
            .environmentObject(financialDataStore)
    }
}
