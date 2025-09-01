//
//  MoneyHoldersScreen.swift
//  AssetsControl
//
//  Created by Igoryok on 14.10.2023.
//

import SwiftUI

struct MoneyHoldersScreen: View {
    @EnvironmentObject private var financesStore: FinancialDataStore

    @State private var isMoneyHolderCreationSheetShowing: Bool = false
    @State private var newMoneyHolder: MoneyHolder?
    @State private var isEditSheetShowing: Bool = false

    var body: some View {
        ScrollView {
            LazyHStack {
                pageView
            }
        }
        .toolbar {
            Button {
                isMoneyHolderCreationSheetShowing = true
            } label: {
                Image(systemName: "plus.circle.fill")
            }
            
//            Button {
//                isEditSheetShowing = true
//            } label: {
//                Image(systemName: "pencil")
//            }
        }
//        .sheet(isPresented: $isEditSheetShowing) {
//            MoneyHolderCreationView(moneyHolder: Binding(
//                get: { financesStore.data.moneyHolders.first(where: { $0.id == data.id }) },
//                set: { newEditedMoneyHolder in
//                    guard let newEditedMoneyHolder else { return }
//
//                    financesStore.data.updateMoneyHolder(withId: data.id, to: newEditedMoneyHolder)
//                }
//            ))
//        }
        .sheet(isPresented: $isMoneyHolderCreationSheetShowing) {
            guard let newMoneyHolder else {
                return
            }

            financesStore.data.addMoneyHolder(newMoneyHolder)
            self.newMoneyHolder = nil
        } content: {
            MoneyHolderCreationView(moneyHolder: $newMoneyHolder)
        }
    }

    private var pageView: some View {
        TabView {
            ForEach(moneyHolders) { moneyHolder in
                MoneyHolderScreen(data: moneyHolder)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .tabViewStyle(PageTabViewStyle())
    }

    private var moneyHolders: [MoneyHolder] {
        financesStore.data.moneyHolders
    }
}

struct MoneyHoldersScreen_Previews: PreviewProvider {
    static var previews: some View {
        MoneyHoldersScreen()
            .environmentObject(FinancialDataStore())
    }
}
