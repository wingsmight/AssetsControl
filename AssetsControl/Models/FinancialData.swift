//
//  FinancialData.swift
//  AssetsControl
//
//  Created by Igoryok on 28.03.2023.
//

import Foundation
import SwiftUI

struct FinancialData: Codable {
    var expenses: [Expense] = []
    var moneyHolders: [MoneyHolder] = []

    private var transactions: [Transaction] = []

    init() {}

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        expenses = (try container.decodeIfPresent([Expense].self, forKey: .expenses)) ?? []
        moneyHolders = (try container.decodeIfPresent([MoneyHolder].self, forKey: .moneyHolders)) ?? []
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(expenses, forKey: .expenses)
        try container.encodeIfPresent(moneyHolders, forKey: .moneyHolders)
    }

    mutating func addExpense(_ newExpense: Expense) {
        expenses.append(newExpense)

        transactions.append(Transaction())
    }

    enum CodingKeys: String, CodingKey {
        case expenses
        case moneyHolders
    }
}
