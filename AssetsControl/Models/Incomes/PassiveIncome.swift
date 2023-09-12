//
//  PassiveIncome.swift
//  AssetsControl
//
//  Created by Igoryok on 09.09.2023.
//

import SwiftUI

class PassiveIncome: AbstractIncome {
    @Published var monthlyEarnings: Money

    init(name: String,
         symbol: Symbol,
         initialDate: Date = Date(),
         source: IncomeSource,
         target: MoneyHolder,
         monthlyEarnings: Money)
    {
        self.monthlyEarnings = monthlyEarnings

        super.init(name: name,
                   symbol: symbol,
                   initialDate: initialDate,
                   source: source,
                   target: target)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        monthlyEarnings = try container.decode(Money.self, forKey: .monthlyEarnings)

        try super.init(from: decoder)
    }

    override func hash(into hasher: inout Hasher) {
        super.hash(into: &hasher)

        hasher.combine(monthlyEarnings.hashValue)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(monthlyEarnings, forKey: .monthlyEarnings)
    }

    private enum CodingKeys: String, CodingKey {
        case monthlyEarnings
    }
}
