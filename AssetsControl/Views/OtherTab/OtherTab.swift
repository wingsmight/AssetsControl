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
    @State private var isMoneyHolderCreationSheetShowing: Bool = false

    @State private var editedMoneyHolder: MoneyHolder?
    @State private var isMoneyHolderEditingSheetShowing: Bool = false

    @State private var moneyHolderRowId: UUID = .init()

    var body: some View {
        VStack {
            addMoneyHolder

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

            Spacer()
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
    }

    var addMoneyHolder: some View {
        Button {
            isMoneyHolderCreationSheetShowing = true
        } label: {
            Label("Add money holder", systemImage: "creditcard")
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
