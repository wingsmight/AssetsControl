//
//  Asset.swift
//  AssetsControl
//
//  Created by Igoryok
//

import SwiftUI

struct Asset: Comparable, Identifiable, Codable, Hashable {
    let id = UUID()

    var name: String
    var symbol: Symbol
    var color: Color
    var amount: Money
    var date: Date
    var moneyHolderSource: MoneyHolder

    init(name: String,
         symbol: Symbol,
         amount: Money,
         moneyHolderSource: MoneyHolder,
         date: Date = Date())
    {
        self.name = name
        self.symbol = symbol
        color = .black
        self.amount = amount
        self.date = date
        self.moneyHolderSource = moneyHolderSource
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        name = try values.decode(String.self, forKey: .name)
        symbol = try values.decode(Symbol.self, forKey: .symbol)
        color = try values.decode(Color.self, forKey: .color)
        amount = try values.decode(Money.self, forKey: .amount)
        date = try values.decode(Date.self, forKey: .date)
        moneyHolderSource = try values.decode(MoneyHolder.self, forKey: .moneyHolderSource)
    }

    static func == (lhs: Asset, rhs: Asset) -> Bool {
        lhs.id == rhs.id
    }

    static func < (lhs: Asset, rhs: Asset) -> Bool {
        lhs.cost < rhs.cost
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(name, forKey: .name)
        try container.encode(symbol, forKey: .symbol)
        try container.encode(color, forKey: .color)
        try container.encode(amount, forKey: .amount)
        try container.encode(date, forKey: .date)
        try container.encode(moneyHolderSource, forKey: .moneyHolderSource)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name.hashValue)
        hasher.combine(symbol.hashValue)
        hasher.combine(color.hashValue)
        hasher.combine(amount.hashValue)
        hasher.combine(moneyHolderSource.hashValue)
    }

    var cost: Money {
        amount
    }

    enum CodingKeys: String, CodingKey {
        case name
        case symbol
        case color
        case amount
        case date
        case moneyHolderSource
    }
}
