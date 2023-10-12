//
//  OtherTab.swift
//  AssetsControl
//
//  Created by Igoryok on 07.04.2023.
//

import SwiftUI

struct OtherTab: View {
    @EnvironmentObject private var financesStore: FinancialDataStore

    @State private var newMoneyHolder: MoneyHolder?
    @State private var editedMoneyHolder: MoneyHolder?
    @State private var isMoneyHolderCreationSheetShowing: Bool = false
    @State private var moneyHolderRowId: UUID = .init()

    @State private var newIncomeSource: IncomeSource?
    @State private var editedIncomeSource: IncomeSource?
    @State private var isIncomeSourceCreationSheetShowing: Bool = false
    @State private var incomeSourceRowId: UUID = .init()

    var body: some View {
        VStack {
            addMoneyHolderButton

            moneyHolderList

            Spacer()

            addIncomeSourceButton

            incomeSourceList
        }
        .navigationTitle("Other")
        .sheet(isPresented: $isMoneyHolderCreationSheetShowing) {
            guard let newMoneyHolder else {
                return
            }

            financesStore.data.addMoneyHolder(newMoneyHolder)
            self.newMoneyHolder = nil
        } content: {
            MoneyHolderCreationView(moneyHolder: $newMoneyHolder)
        }
        .sheet(item: $editedMoneyHolder) { editedMoneyHolder in
            MoneyHolderCreationView(moneyHolder: Binding(
                get: { financesStore.data.moneyHolders.first(where: { $0.id == editedMoneyHolder.id }) },
                set: { newEditedMoneyHolder in
                    guard let newEditedMoneyHolder else { return }

                    financesStore.data.updateMoneyHolder(withId: newEditedMoneyHolder.id, to: newEditedMoneyHolder)

                    moneyHolderRowId = UUID()
                }
            ))
        }
        .sheet(isPresented: $isIncomeSourceCreationSheetShowing) {
            guard let newIncomeSource else {
                return
            }

            financesStore.data.addIncomeSource(newIncomeSource)
            self.newIncomeSource = nil
        } content: {
            IncomeSourceCreationView(incomeSource: $newIncomeSource)
        }
        .sheet(item: $editedIncomeSource) { editedIncomeSource in
            IncomeSourceCreationView(incomeSource: Binding(
                get: { financesStore.data.incomeSources.first(where: { $0.id == editedIncomeSource.id }) },
                set: { newEditedIncomeSource in
                    guard let newEditedIncomeSource else { return }

                    financesStore.data.updateIncomeSource(withId: newEditedIncomeSource.id, to: newEditedIncomeSource)

                    incomeSourceRowId = UUID()
                }
            ))
        }
    }

    var addMoneyHolderButton: some View {
        Button {
            isMoneyHolderCreationSheetShowing = true
        } label: {
            Label("Add Money Holder", systemImage: "creditcard")
        }
    }

    var moneyHolderList: some View {
        List {
            ForEach(financesStore.data.moneyHolders) { moneyHolder in
                Button {
                    editedMoneyHolder = moneyHolder
                } label: {
                    MoneyHolderRowView(data: moneyHolder)
                        .id(moneyHolderRowId)
                }
            }
            .onDelete { indexSet in
                financesStore.data.removeMoneyHolder(atOffsets: indexSet)
            }
        }
    }

    var addIncomeSourceButton: some View {
        Button {
            isIncomeSourceCreationSheetShowing = true
        } label: {
            Label("Add Income Source", systemImage: "chart.bar.fill")
        }
    }

    var incomeSourceList: some View {
        List {
            ForEach(financesStore.data.incomeSources) { incomeSource in
                Button {
                    editedIncomeSource = incomeSource
                } label: {
                    IncomeSourceRowView(data: incomeSource)
                        .id(incomeSourceRowId)
                }
            }
            .onDelete { indexSet in
                financesStore.data.removeIncomeSource(atOffsets: indexSet)
            }
        }
    }
}

struct OtherTab_Previews: PreviewProvider {
    @StateObject private static var financialDataStore = FinancialDataStore()

    static var previews: some View {
        OtherTab()
            .environmentObject(financialDataStore)
    }
}
