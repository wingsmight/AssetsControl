//
//  NetWorthView.swift
//  AssetsControl
//
//  Created by Igoryok
//

import SwiftUI

struct NetWorthView: View {
    @EnvironmentObject private var financesStore: FinancialDataStore

    @State private var netWorth = 0.0
    @State private var rubUsdRate = 0.0
    @State private var usdRubRate = 0.0

    var body: some View {
        VStack {
            Text(netWorth.description)

            Text(rubUsdRate.description)

            Text(usdRubRate.description)
        }
        .onAppear {
            CurrencyExchangeAPI.shared.fetchExchangeRate(from: "rub", to: "usd") { result in
                switch result {
                case let .success(rate):
                    print("Exchange rate: \(rate)")
                    rubUsdRate = rate
                case let .failure(error):
                    print("Failed to fetch exchange rate: \(error)")
                }
            }

            CurrencyExchangeAPI.shared.fetchExchangeRate(from: "usd", to: "rub") { result in
                switch result {
                case let .success(rate):
                    print("Exchange rate: \(rate)")
                    usdRubRate = rate
                case let .failure(error):
                    print("Failed to fetch exchange rate: \(error)")
                }
            }
        }
        .task {
            if let netWorth = try? await financesStore.data.netWorth(in: .russianRuble) {
                self.netWorth = netWorth
            }
        }
    }
}
