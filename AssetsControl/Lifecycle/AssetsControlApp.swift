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
    @StateObject private var userDataStore = UserDataStore()
    @StateObject private var preferencesDataStore = PreferencesDataStore()

    @State private var isLoading = true

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(financialDataStore)
                .environmentObject(userDataStore)
                .environmentObject(preferencesDataStore)
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
                    
                    UserDataStore.load { result in
                        switch result {
                        case .failure:
                            userDataStore.data = UserData()
                        case let .success(data):
                            userDataStore.data = data
                        }

                        isLoading = false
                    }
                    
                    PreferencesDataStore.load { result in
                        switch result {
                        case .failure:
                            preferencesDataStore.data = PreferencesData()
                        case let .success(data):
                            preferencesDataStore.data = data
                        }

                        isLoading = false
                    }
                }
                .onChange(of: scenePhase) { phase in
                    if scenePhase == .active, phase == .inactive {
                        FinancialDataStore.save(financialDataStore.data) { _ in }
                        UserDataStore.save(userDataStore.data) { _ in }
                        PreferencesDataStore.save(preferencesDataStore.data) { _ in }
                    }
                }
        }
    }
}
