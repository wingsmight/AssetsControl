//
//  MoneyHolder.swift
//  AssetsControl
//
//  Created by Igoryok on 07.04.2023.
//

import Foundation

struct MoneyHolder: Codable, Identifiable, Hashable {
    private static let defaultSymbol: Symbol = .creditCard

    let id: UUID

    var name: String
    var description: String
    var symbol: Symbol
    var initialMoney: Money
    var initialDate: Date = .init()

    init(id: UUID? = UUID(),
         name: String,
         description: String = "",
         symbol: Symbol = defaultSymbol,
         initialMoney: Money = Money(0),
         initialDate: Date = Date())
    {
        self.id = id ?? UUID()
        self.name = name
        self.description = description
        self.symbol = symbol
        self.initialMoney = initialMoney
        self.initialDate = initialDate
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        name = try values.decode(String.self, forKey: .name)
        description = try values.decode(String.self, forKey: .description)
        symbol = try values.decode(Symbol.self, forKey: .symbol)
        initialMoney = try values.decode(Money.self, forKey: .initialMoney)
        initialDate = try values.decode(Date.self, forKey: .initialDate)
    }

    static func == (lhs: MoneyHolder, rhs: MoneyHolder) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id.hashValue)
        hasher.combine(name.hashValue)
        hasher.combine(description.hashValue)
        hasher.combine(symbol.hashValue)
        hasher.combine(initialMoney.hashValue)
        hasher.combine(initialDate.hashValue)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(symbol, forKey: .symbol)
        try container.encode(initialMoney, forKey: .initialMoney)
        try container.encode(initialDate, forKey: .initialDate)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case symbol
        case initialMoney
        case initialDate
    }
}
