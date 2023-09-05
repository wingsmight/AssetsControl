//
//  Money.swift
//
//  Created by Igoryok
//

import Foundation

struct Money: Hashable, Codable, CustomStringConvertible {
    var count: Double
    let currency: Currency

    init(_ count: Double, of currency: Currency = .ruble) {
        self.count = count
        self.currency = currency
    }

    static func * (money: Money, count: Int) -> Money {
        Money(money.count * Double(count), of: money.currency)
    }

    var description: String {
        let formattedCount = StringFormatterContainer.rubMoney.string(from: count as NSNumber)
        let countText = formattedCount ?? count.description

        return "\(countText) \(currency.symbol)"
    }
}
