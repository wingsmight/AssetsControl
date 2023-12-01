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
    
    var body: some View {
//        NavigationView {
            ScrollView {
                LazyHStack {
                    pageView
                }
            }
//            .navigationTitle("Money holders")
            .toolbar {
                Button {
                    isMoneyHolderCreationSheetShowing = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
            }
            .sheet(isPresented: $isMoneyHolderCreationSheetShowing) {
                guard let newMoneyHolder else {
                    return
                }

                financesStore.data.addMoneyHolder(newMoneyHolder)
                self.newMoneyHolder = nil
            } content: {
                MoneyHolderCreationView(moneyHolder: $newMoneyHolder)
            }
//        }
    }

    private var pageView: some View {
        TabView {
            ForEach(moneyHolder) { moneyHolder in
                MoneyHolderScreen(data: moneyHolder)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .tabViewStyle(PageTabViewStyle())
    }

    private var moneyHolder: [MoneyHolder] {
        financesStore.data.moneyHolders
    }
}

struct MoneyHoldersScreen_Previews: PreviewProvider {
    static var previews: some View {
        MoneyHoldersScreen()
    }
}
