//
//  AssetsTab.swift
//  AssetsControl
//
//  Created by Igoryok on 28.03.2023.
//

import SwiftUI

struct AssetsTab: View {
    @EnvironmentObject private var financesStore: FinancialDataStore
    
    var body: some View {
        Text("AssetsTab")
    }
}

struct AssetsTab_Previews: PreviewProvider {
    @StateObject private static var financialDataStore = FinancialDataStore()
    
    static var previews: some View {
        AssetsTab()
            .environmentObject(financialDataStore)
    }
}
