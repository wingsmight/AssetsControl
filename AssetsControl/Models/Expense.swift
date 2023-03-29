//
//  Expense.swift
//  AssetsControl
//
//  Created by Igoryok on 28.03.2023.
//

import Foundation

class Expense: ObservableObject, Comparable, Identifiable, Codable, Hashable {
    let fromDebt: Bool

    @Published var name: String
    @Published var symbol: Symbol
    @Published var colorHex: String
    @Published var baseMonthlyCost: Double
    @Published var children: [Expense]
    @Published var date: Date

    init(name: String, symbol: Symbol, monthlyCost: Double) {
        self.name = name
        self.symbol = symbol
        colorHex = "000000"
        baseMonthlyCost = monthlyCost
        fromDebt = false
        children = []
        date = Date()
    }

    init(debt: Debt) {
        name = debt.name
        symbol = debt.symbol
        colorHex = debt.colorHex
        baseMonthlyCost = debt.monthlyPayment
        fromDebt = true
        children = []
        date = Date()
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        let symbolName = try values.decode(String.self, forKey: .symbol)

        name = try values.decode(String.self, forKey: .name)
        symbol = .init(rawValue: symbolName) ?? .init(rawValue: Symbol.defaultSymbol.rawValue)!
        colorHex = try values.decode(String.self, forKey: .colorHex)
        baseMonthlyCost = try values.decode(Double.self, forKey: .monthlyCost)
        fromDebt = false
        children = (try? values.decode([Expense].self, forKey: .children)) ?? []
        date = try values.decode(Date.self, forKey: .date)
    }

    static func == (lhs: Expense, rhs: Expense) -> Bool {
        lhs.id == rhs.id
    }

    static func < (lhs: Expense, rhs: Expense) -> Bool {
        lhs.monthlyCost < rhs.monthlyCost
    }
    
    func encode(to encoder: Encoder) throws {
        guard !fromDebt else { throw CodingError.isFromDebt }

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(name, forKey: .name)
        try container.encode(symbol.rawValue, forKey: .symbol)
        try container.encode(colorHex, forKey: .colorHex)
        try container.encode(baseMonthlyCost, forKey: .monthlyCost)
        try container.encode(children, forKey: .children)
        try container.encode(date, forKey: .date)
    }
    
    func hash(into hasher: inout Hasher) {       
        hasher.combine(fromDebt.hashValue)
        hasher.combine(name.hashValue)
        hasher.combine(symbol.hashValue)
        hasher.combine(colorHex.hashValue)
        hasher.combine(baseMonthlyCost.hashValue)
        hasher.combine(children.hashValue)
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
    }

    enum CodingError: Error {
        case isFromDebt
    }
}
