//
//  Money.swift
//
//  Created by Igoryok
//

import Foundation

struct Money: Hashable, Codable, CustomStringConvertible {
    var count: Int
    let currency: Currency

    init(_ count: Int, of currency: Currency = .ruble) {
        self.count = count
        self.currency = currency
    }
    
    static func * (money: Money, count: Int) -> Money {
        return Money(money.count * count, of: money.currency)
    }

    var description: String {
        let formattedCount = StringFormatterContainer.rubMoney.string(from: count as NSNumber)
        
        let countText = formattedCount ?? count.description
        
        return "\(countText) \(currency.symbol)"
    }
}
