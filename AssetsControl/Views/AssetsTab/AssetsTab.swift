//
//  AssetsTab.swift
//  AssetsControl
//
//  Created by Igoryok on 28.03.2023.
//

import SwiftUI

struct AssetsTab: View {
    @EnvironmentObject private var financesStore: FinancialDataStore
    @EnvironmentObject private var userStore: UserDataStore

    @State private var isNewAssetSheetShowing: Bool = false
    @State private var asset: Asset? = nil

    var body: some View {
        NavigationView {
            List {
                NetWorthView()
                
                NavigationLink("Analytics", destination: AnalyticsTab())
                
                ForEach(assetGroupHeaders, id: \.self) { headerDate in
                    Section(header: Text(headerDate, style: .date)) {
                        ForEach(assetGroups[headerDate]!) { asset in
                            AssetRowView(asset: asset)
                        }
                        .onDelete { offsetIndexSet in
                            removeAssets(at: offsetIndexSet, for: headerDate)
                        }
                    }
                }
            }
            .navigationTitle("Assets")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isNewAssetSheetShowing = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .foregroundColor(.red)
                }
            }
            .sheet(isPresented: $isNewAssetSheetShowing) {
                AssetCreationView(asset: $asset,
                                  isShowing: $isNewAssetSheetShowing)
            }
            .onChange(of: asset) { newAsset in
                if let newAsset {
                    financesStore.data.addAsset(newAsset)
                }
            }
        }
    }

    private func removeAssets(at offsets: IndexSet, for headerDate: Date) {
        guard let assetGroup = assetGroups[headerDate] else { return }
        let removedAssets = offsets.map { assetGroup[$0] }

        financesStore.data.removeAssets(removedAssets)
    }

    private var assetGroups: [Date: [Asset]] {
        financesStore.data.assets.sliced(by: [.year, .month, .day], for: \.date)
    }

    private var assetGroupHeaders: [Date] {
        assetGroups
            .map(\.key)
            .sorted { $0 > $1 }
    }
}

struct AssetsTab_Previews: PreviewProvider {
    @StateObject private static var financialDataStore = FinancialDataStore()

    static var previews: some View {
        AssetsTab()
            .environmentObject(financialDataStore)
    }
}
