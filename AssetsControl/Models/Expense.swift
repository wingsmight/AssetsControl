//
//  Expense.swift
//  AssetsControl
//
//  Created by Igoryok on 28.03.2023.
//

import Foundation

class Expense: ObservableObject, Comparable, Identifiable, Codable, Hashable {
    @Published var name: String
    @Published var symbol: Symbol
    @Published var colorHex: String
    @Published var baseMonthlyCost: Double
    @Published var children: [Expense]
    @Published var date: Date
    @Published var moneyHolderSource: MoneyHolder

    init(name: String,
         symbol: Symbol,
         monthlyCost: Double,
         moneyHolderSource: MoneyHolder)
    {
        self.name = name
        self.symbol = symbol
        colorHex = "000000"
        baseMonthlyCost = monthlyCost
        children = []
        date = Date()
        self.moneyHolderSource = moneyHolderSource
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        let symbolName = try values.decode(String.self, forKey: .symbol)

        name = try values.decode(String.self, forKey: .name)
        symbol = .init(rawValue: symbolName) ?? .init(rawValue: Symbol.defaultSymbol.rawValue)!
        colorHex = try values.decode(String.self, forKey: .colorHex)
        baseMonthlyCost = try values.decode(Double.self, forKey: .monthlyCost)
        children = (try? values.decodeIfPresent([Expense].self, forKey: .children)) ?? []
        date = try values.decode(Date.self, forKey: .date)
        moneyHolderSource = try values.decode(MoneyHolder.self, forKey: .moneyHolderSource)
    }

    static func == (lhs: Expense, rhs: Expense) -> Bool {
        lhs.id == rhs.id
    }

    static func < (lhs: Expense, rhs: Expense) -> Bool {
        lhs.monthlyCost < rhs.monthlyCost
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(name, forKey: .name)
        try container.encode(symbol.rawValue, forKey: .symbol)
        try container.encode(colorHex, forKey: .colorHex)
        try container.encode(baseMonthlyCost, forKey: .monthlyCost)
        try container.encode(children, forKey: .children)
        try container.encode(date, forKey: .date)
        try container.encode(moneyHolderSource, forKey: .moneyHolderSource)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name.hashValue)
        hasher.combine(symbol.hashValue)
        hasher.combine(colorHex.hashValue)
        hasher.combine(baseMonthlyCost.hashValue)
        hasher.combine(children.hashValue)
        hasher.combine(moneyHolderSource.hashValue)
    }

    var id: String {
        name + symbol.rawValue
    }

    var monthlyCost: Double {
        baseMonthlyCost + children.reduce(0) { $0 + $1.baseMonthlyCost }
    }

    enum CodingKeys: String, CodingKey {
        case name
        case symbol
        case colorHex
        case monthlyCost
        case children
        case date
        case moneyHolderSource
    }
}
