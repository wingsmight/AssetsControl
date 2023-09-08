//
//  FinancialData.swift
//  AssetsControl
//
//  Created by Igoryok on 28.03.2023.
//

import Foundation
import SwiftUI

struct FinancialData: Codable {
    private(set) var expenses: [Expense] = []
    private(set) var moneyHolders: [MoneyHolder] = []

    private var transactions: [Transaction] = []

    init() {}

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        expenses = try container.decodeIfPresent([Expense].self, forKey: .expenses) ?? []
        moneyHolders = try container.decodeIfPresent([MoneyHolder].self, forKey: .moneyHolders) ?? []
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(expenses, forKey: .expenses)
        try container.encodeIfPresent(moneyHolders, forKey: .moneyHolders)
    }

    mutating func addMoneyHolder(_ newMoneyHolder: MoneyHolder) {
        moneyHolders.insert(newMoneyHolder, at: 0)
    }

    mutating func removeMoneyHolder(atOffsets offsets: IndexSet) {
        moneyHolders.remove(atOffsets: offsets)
    }

    mutating func addExpense(_ newExpense: Expense) {
        expenses.insert(newExpense, at: 0)

        transactions.append(Transaction())
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

    enum CodingKeys: String, CodingKey {
        case expenses
        case moneyHolders
    }
}
