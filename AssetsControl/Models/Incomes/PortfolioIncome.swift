//
//  PortfolioIncome.swift
//  AssetsControl
//
//  Created by Igoryok on 12.09.2023.
//

import Foundation

class PortfolioIncome: AbstractIncome {
    @Published var amount: Money

    init(name: String,
         symbol: Symbol,
         initialDate: Date = Date(),
         source: IncomeSource,
         target: MoneyHolder,
         amount: Money)
    {
        self.amount = amount

        super.init(name: name,
                   symbol: symbol,
                   initialDate: initialDate,
                   source: source,
                   target: target)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        amount = try container.decode(Money.self, forKey: .amount)

        try super.init(from: decoder)
    }

    override func hash(into hasher: inout Hasher) {
        super.hash(into: &hasher)

        hasher.combine(amount.hashValue)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(amount, forKey: .amount)
    }

    private enum CodingKeys: String, CodingKey {
        case amount
    }
}
