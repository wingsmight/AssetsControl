//
//  MoneyHolder.swift
//  AssetsControl
//
//  Created by Igoryok on 07.04.2023.
//

import Foundation

struct MoneyHolder: Codable, Identifiable, Hashable {
    var name: String
    var description: String
    var symbol: Symbol
    var initialMoney: Money
    var initialDate: Date = Date()
    
    private(set) var id = UUID()

    init(name: String,
         description: String = "",
         symbol: Symbol = .creditCard,
         initialMoney: Money = Money(0),
         initialDate: Date = Date())
    {
        self.name = name
        self.description = description
        self.symbol = symbol
        self.initialMoney = initialMoney
        self.initialDate = initialDate
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        let symbolName = try values.decode(String.self, forKey: .symbol)

        name = try values.decode(String.self, forKey: .name)
        description = try values.decode(String.self, forKey: .description)
        symbol = .init(rawValue: symbolName) ?? .init(rawValue: Symbol.defaultSymbol.rawValue)!
        initialMoney = try values.decode(Money.self, forKey: .initialMoney)
        initialDate = try values.decode(Date.self, forKey: .initialDate)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(symbol.rawValue, forKey: .symbol)
        try container.encode(initialMoney, forKey: .initialMoney)
        try container.encode(initialDate, forKey: .initialDate)
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case symbol
        case initialMoney
        case initialDate
    }
}
