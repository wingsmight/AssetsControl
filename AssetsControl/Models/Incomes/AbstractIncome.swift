//
//  AbstractIncome.swift
//  AssetsControl
//
//  Created by Igoryok on 12.09.2023.
//

import Foundation

class AbstractIncome: Income {
    let id = UUID()

    @Published var name: String
    @Published var symbol: Symbol
    @Published var initialDate: Date = .init()
    @Published var source: IncomeSource
    @Published var target: MoneyHolder

    init(name: String,
         symbol: Symbol,
         initialDate: Date = Date(),
         source: IncomeSource,
         target: MoneyHolder)
    {
        self.name = name
        self.symbol = symbol
        self.initialDate = initialDate
        self.source = source
        self.target = target
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(String.self, forKey: .name)
        symbol = try container.decode(Symbol.self, forKey: .symbol)
        initialDate = try container.decode(Date.self, forKey: .initialDate)
        source = try container.decode(IncomeSource.self, forKey: .source)
        target = try container.decode(MoneyHolder.self, forKey: .target)
    }

    static func == (lhs: AbstractIncome, rhs: AbstractIncome) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name.hashValue)
        hasher.combine(symbol.hashValue)
        hasher.combine(initialDate.hashValue)
        hasher.combine(source.hashValue)
        hasher.combine(target.hashValue)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(symbol, forKey: .symbol)
        try container.encode(initialDate, forKey: .initialDate)
        try container.encode(source, forKey: .source)
        try container.encode(target, forKey: .target)
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case initialDate
        case source
        case target
    }
}
