//
//  OtherTab.swift
//  AssetsControl
//
//  Created by Igoryok on 07.04.2023.
//

import SwiftUI

struct OtherTab: View {
    @EnvironmentObject private var financesStore: FinancialDataStore

    @State private var isMoneyHolderCreationSheetShowing: Bool = false
    @State private var newMoneyHolder: MoneyHolder?

    var body: some View {
        VStack {
            addMoneyHolder

            List {
                ForEach(financesStore.data.moneyHolders) { moneyHolder in
                    MoneyHolderRowView(data: moneyHolder)
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
            MoneyHolderCreationView(moneyHolder: $newMoneyHolder, isShowing: $isMoneyHolderCreationSheetShowing)
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
    static var previews: some View {
        OtherTab()
    }
}
