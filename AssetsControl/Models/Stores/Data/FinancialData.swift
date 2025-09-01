//
//  FinancialData.swift
//  AssetsControl
//
//  Created by Igoryok on 28.03.2023.
//

import SwiftUI

struct FinancialData: Codable {
    private(set) var moneyHolders: [MoneyHolder] = []
    private(set) var incomeSources: [IncomeSource] = []
    private(set) var incomes: [any Income] = []
    private(set) var expenses: [Expense] = []
    private(set) var transfers: [Transfer] = []
    private(set) var assets: [Asset] = []

    init() {}

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        moneyHolders = try container.decodeIfPresent([MoneyHolder].self, forKey: .moneyHolders) ?? []
        incomeSources = try container.decodeIfPresent([IncomeSource].self, forKey: .incomeSources) ?? []
        incomes = try decodeIncomes(container: container)
        expenses = try container.decodeIfPresent([Expense].self, forKey: .expenses) ?? []
        transfers = try container.decodeIfPresent([Transfer].self, forKey: .transfers) ?? []
        assets = try container.decodeIfPresent([Asset].self, forKey: .assets) ?? []
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(moneyHolders, forKey: .moneyHolders)
        try container.encodeIfPresent(incomeSources, forKey: .incomeSources)
        try encodeIncomes(container: &container)
        try container.encodeIfPresent(expenses, forKey: .expenses)
        try container.encodeIfPresent(transfers, forKey: .transfers)
        try container.encodeIfPresent(assets, forKey: .assets)
    }

    private func decodeIncomes(container: KeyedDecodingContainer<FinancialData.CodingKeys>) throws -> [any Income] {
        let incomeTypes = try (container.decodeIfPresent([IncomeType].self, forKey: .incomeTypes) ?? [])

        return incomeTypes.map(\.income)
    }

    private func encodeIncomes(container: inout KeyedEncodingContainer<FinancialData.CodingKeys>) throws {
        let incomeTypes = incomes.compactMap { try? $0.incomeType }

        try container.encodeIfPresent(incomeTypes, forKey: .incomeTypes)
    }

    enum CodingKeys: String, CodingKey {
        case moneyHolders
        case incomeSources
        case incomeTypes
        case expenses
        case transfers
        case assets
    }
}

extension FinancialData {
    mutating func addMoneyHolder(_ newMoneyHolder: MoneyHolder) {
        moneyHolders.insert(newMoneyHolder, at: 0)
    }

    mutating func removeMoneyHolder(atOffsets offsets: IndexSet) {
        moneyHolders.remove(atOffsets: offsets)
    }

    mutating func removeMoneyHolder(_ removedMoneyHolder: MoneyHolder) {
        if let index = moneyHolders.firstIndex(of: removedMoneyHolder) {
            moneyHolders.remove(at: index)
        }
    }

    mutating func updateMoneyHolder(withId moneyHolderId: UUID, to updatedMoneyHolder: MoneyHolder) {
        guard let index = moneyHolders.firstIndex(where: { $0.id == moneyHolderId }) else { return }

        moneyHolders[index] = updatedMoneyHolder
    }
}

extension FinancialData {
    mutating func addIncomeSource(_ newIncomeSource: IncomeSource) {
        incomeSources.insert(newIncomeSource, at: 0)
    }

    mutating func removeIncomeSource(atOffsets offsets: IndexSet) {
        incomeSources.remove(atOffsets: offsets)
    }

    mutating func updateIncomeSource(withId incomeSourceId: UUID, to updatedIncomeSource: IncomeSource) {
        guard let index = incomeSources.firstIndex(where: { $0.id == incomeSourceId }) else { return }

        incomeSources[index] = updatedIncomeSource
    }
}

extension FinancialData {
    mutating func addIncome(_ newIncome: any Income) {
        incomes.insert(newIncome, at: 0)
    }

    mutating func removeIncome(atOffsets offsets: IndexSet) {
        incomes.remove(atOffsets: offsets)
    }

    mutating func removeIncome(_ removedIncome: any Income) {
        incomes.removeAll { $0.id == removedIncome.id }
    }

    mutating func removeIncomes(_ removedIncomes: [any Income]) {
        removedIncomes.forEach { removeIncome($0) }
    }
}

extension FinancialData {
    var activeIncomes: [ActiveIncome] {
        incomes.compactMap { $0 as? ActiveIncome }
    }
}

extension FinancialData {
    mutating func addExpense(_ newExpense: Expense) {
        expenses.insert(newExpense, at: 0)
    }

    mutating func removeExpense(atOffsets offsets: IndexSet) {
        expenses.remove(atOffsets: offsets)
    }

    mutating func removeExpense(_ removedExpense: Expense) {
        expenses.removeAll { $0 == removedExpense }
    }

    mutating func removeExpenses(_ removedExpenses: [Expense]) {
        expenses.removeAll { removedExpenses.contains($0) }
    }
}

extension FinancialData {
    mutating func addTransfer(_ newTransfer: Transfer) {
        transfers.insert(newTransfer, at: 0)
    }

    mutating func removeTransfer(atOffsets offsets: IndexSet) {
        transfers.remove(atOffsets: offsets)
    }

    mutating func removeTransfer(_ removedTransfer: Transfer) {
        transfers.removeAll { $0 == removedTransfer }
    }

    mutating func removeTransfers(_ removedTransfers: [Transfer]) {
        transfers.removeAll { removedTransfers.contains($0) }
    }

    mutating func updateTransfer(withId transferId: UUID, to updatedTransfer: Transfer) {
        guard let index = transfers.firstIndex(where: { $0.id == transferId }) else { return }

        transfers[index] = updatedTransfer
    }
}

extension FinancialData {
    func getExpenses(for moneyHolder: MoneyHolder) -> [Expense] {
        expenses.filter { $0.moneyHolderSource == moneyHolder }
    }

    func getActiveIncomes(for moneyHolder: MoneyHolder) -> [ActiveIncome] {
        activeIncomes.filter { $0.target == moneyHolder }
    }

    func getIncomeTransfers(for moneyHolder: MoneyHolder) -> [Transfer] {
        transfers.filter { $0.target == moneyHolder }
    }

    func getOutcomeTransfers(for moneyHolder: MoneyHolder) -> [Transfer] {
        transfers.filter { $0.source == moneyHolder }
    }

    func getAssetExpenses(for moneyHolder: MoneyHolder) -> [Asset] {
        assets.filter { $0.moneyHolderSource == moneyHolder }
    }

    func getCurrentAmount(for moneyHolder: MoneyHolder) -> Money {
        var totalAmount = getExpenses(for: moneyHolder).reduce(moneyHolder.initialMoney) { $0 - $1.amount }
        totalAmount = getActiveIncomes(for: moneyHolder).reduce(totalAmount) { $0 + $1.amount }

        totalAmount = getIncomeTransfers(for: moneyHolder).reduce(totalAmount) { $0 + $1.receivedMoneyAmount }
        totalAmount = getOutcomeTransfers(for: moneyHolder).reduce(totalAmount) { $0 - $1.moneyAmount }
        
        totalAmount = getAssetExpenses(for: moneyHolder).reduce(totalAmount) { $0 - $1.amount }

        return totalAmount
    }
}

extension FinancialData {
    mutating func addAsset(_ newAsset: Asset) {
        assets.insert(newAsset, at: 0)
    }

    mutating func removeAsset(atOffsets offsets: IndexSet) {
        assets.remove(atOffsets: offsets)
    }

    mutating func removeAsset(_ removedAsset: Asset) {
        assets.removeAll { $0 == removedAsset }
    }

    mutating func removeAssets(_ removedAssets: [Asset]) {
        assets.removeAll { removedAssets.contains($0) }
    }
}

extension FinancialData {
//    var networth: Double {
    ////        moneyHolders.reduce(0) { $0 + $1.initialMoney.count }
//        moneyHolders.reduce(into: <#T##Result#>) { _, moneyHolder in
//            CurrencyExchangeAPI.shared.fetchExchangeRate(from: moneyHolder.initialMoney.currency.code.lowercased(), to: "rub", completion: { _ in
//
//            })
//        }
//    }

    func netWorth(in targetCurrency: Currency) async throws -> Double {
        let targetCurrencyCode = targetCurrency.code.lowercased()

        return try await moneyHolders.asyncReduce(0.0) { partialResult, moneyHolder in
            // Fetch the exchange rate from the money's currency to RUB
            let currentMoney = getCurrentAmount(for: moneyHolder)
            let exchangeRate = try await withCheckedThrowingContinuation { continuation in
                CurrencyExchangeAPI.shared.fetchExchangeRate(from: currentMoney.currency.code.lowercased(),
                                                             to: targetCurrencyCode)
                { result in
                    switch result {
                    case let .success(rate):
                        continuation.resume(returning: rate)
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                }
            }

            // Convert the money to RUB and add to the running total
            let convertedMoneyAmount = currentMoney.count * exchangeRate
            return partialResult + convertedMoneyAmount
        }
    }
}
