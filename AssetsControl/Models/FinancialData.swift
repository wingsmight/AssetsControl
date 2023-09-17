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

    init() {}

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        moneyHolders = try container.decodeIfPresent([MoneyHolder].self, forKey: .moneyHolders) ?? []
        incomeSources = try container.decodeIfPresent([IncomeSource].self, forKey: .incomeSources) ?? []
        incomes = try decodeIncomes(container: container)
        expenses = try container.decodeIfPresent([Expense].self, forKey: .expenses) ?? []
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(moneyHolders, forKey: .moneyHolders)
        try container.encodeIfPresent(incomeSources, forKey: .incomeSources)
        try encodeIncomes(container: &container)
        try container.encodeIfPresent(expenses, forKey: .expenses)
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
    }
}

extension FinancialData {
    mutating func addMoneyHolder(_ newMoneyHolder: MoneyHolder) {
        moneyHolders.insert(newMoneyHolder, at: 0)
    }

    mutating func removeMoneyHolder(atOffsets offsets: IndexSet) {
        moneyHolders.remove(atOffsets: offsets)
    }
}

extension FinancialData {
    mutating func addIncomeSource(_ newIncomeSource: IncomeSource) {
        incomeSources.insert(newIncomeSource, at: 0)
    }
    
    mutating func removeIncomeSource(atOffsets offsets: IndexSet) {
        incomeSources.remove(atOffsets: offsets)
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
