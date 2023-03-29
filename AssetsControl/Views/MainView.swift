//
//  MainView.swift
//  AssetsControl
//
//  Created by Igoryok on 28.03.2023.
//

import SwiftUI

struct MainView: View {
    private let expensesTabIndex = 0
    private let assetsTabIndex = 1
    
    @EnvironmentObject private var financesStore: FinancialDataStore
    
    @State private var selectedTabIndex = 0
    
    var body: some View {
        TabView(selection: $selectedTabIndex) {
            ExpensesTab()
                .tabItem {
                    Label("Expenses", systemImage: "list.clipboard.fill")
                }
                .tag(expensesTabIndex)
            
            AssetsTab()
                .tabItem {
                    Label("Assets", systemImage: "banknote.fill")
                }
                .tag(assetsTabIndex)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
