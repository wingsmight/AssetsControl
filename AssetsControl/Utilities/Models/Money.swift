//
//  Money.swift
//
//  Created by Igoryok
//

import Foundation

struct Money: Hashable, Codable, CustomStringConvertible, Comparable {
    private static let defaultCurrency: Currency = .dollar // TODO: make it dynamic depending on user's region

    var count: Double
    let currency: Currency

    init(_ count: Double, of currency: Currency = defaultCurrency) {
        self.count = count
        self.currency = currency
    }

    static func * (money: Money, count: Int) -> Money {
        Money(money.count * Double(count), of: money.currency)
    }

    static func + (lhs: Money, rhs: Money) -> Money {
        // TODO: convert from one currency to other
        guard lhs.currency == rhs.currency else {
            fatalError("Attempted to add money with different currencies: \(lhs.currency) and \(rhs.currency)")
        }

        return Money(lhs.count + rhs.count, of: lhs.currency)
    }

    static func > (lhs: Money, rhs: Money) -> Bool {
        // TODO: convert from one currency to other
        guard lhs.currency == rhs.currency else {
            fatalError("Attempted to compare money with different currencies: \(lhs.currency) and \(rhs.currency)")
        }

        return lhs.count > rhs.count
    }

    static func < (lhs: Money, rhs: Money) -> Bool {
        // TODO: convert from one currency to other
        guard lhs.currency == rhs.currency else {
            fatalError("Attempted to compare money with different currencies: \(lhs.currency) and \(rhs.currency)")
        }

        return lhs.count < rhs.count
    }

    var description: String {
        let formattedCount = StringFormatterContainer.rubMoney.string(from: count as NSNumber)
        let countText = formattedCount ?? count.description

        return "\(countText) \(currency.symbol)"
    }
}
