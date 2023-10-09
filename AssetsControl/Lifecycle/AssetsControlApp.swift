//
//  AssetsControlApp.swift
//  AssetsControl
//
//  Created by Igoryok on 28.03.2023.
//

import SwiftUI

@main
struct AssetsControlApp: App {
    @Environment(\.scenePhase) private var scenePhase

    @StateObject private var financialDataStore = FinancialDataStore()

    @State private var isLoading = true

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(financialDataStore)
                .onAppear {
                    isLoading = true

                    FinancialDataStore.load { result in
                        switch result {
                        case .failure:
                            financialDataStore.data = FinancialData()
                        case let .success(data):
                            financialDataStore.data = data
                        }

                        isLoading = false
                    }
                }
                .onChange(of: scenePhase) { phase in
                    if scenePhase == .active, phase == .inactive {
                        FinancialDataStore.save(financialDataStore.data) { _ in }
                    }
                }
        }
    }
}
