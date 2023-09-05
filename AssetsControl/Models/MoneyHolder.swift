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
    var money: Money

    init(name: String,
         description: String = "",
         symbol: Symbol = .creditCard,
         money: Money = Money(0))
    {
        self.name = name
        self.description = description
        self.symbol = symbol
        self.money = money
    }

    private(set) var id = UUID()
}
