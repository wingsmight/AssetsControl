//
//  Transfer.swift
//  AssetsControl
//
//  Created by Igoryok on 28.03.2023.
//

import SwiftUI

struct Transfer: Identifiable, Codable, Hashable {
    let id = UUID()

    var source: MoneyHolder
    var target: MoneyHolder
    var description: String?
    var amount: Double
    var receivedAmount: Double
    var date: Date

    init(source: MoneyHolder,
         target: MoneyHolder,
         description: String? = nil,
         amount: Double,
         receivedAmount: Double? = nil,
         date: Date = Date())
    {
        self.source = source
        self.target = target
        self.description = description
        self.amount = amount
        self.receivedAmount = receivedAmount ?? amount
        self.date = date
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        source = try values.decode(MoneyHolder.self, forKey: .source)
        target = try values.decode(MoneyHolder.self, forKey: .target)
        description = try values.decode(String.self, forKey: .description)
        amount = try values.decode(Double.self, forKey: .amount)
        receivedAmount = try values.decodeIfPresent(Double.self, forKey: .receivedAmount) ?? amount
        date = try values.decode(Date.self, forKey: .date)
    }

    static func == (lhs: Transfer, rhs: Transfer) -> Bool {
        lhs.id == rhs.id
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(source, forKey: .source)
        try container.encode(target, forKey: .target)
        try container.encode(description, forKey: .description)
        try container.encode(amount, forKey: .amount)
        try container.encode(receivedAmount, forKey: .receivedAmount)
        try container.encode(date, forKey: .date)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(source.hashValue)
        hasher.combine(target.hashValue)
        hasher.combine(description.hashValue)
        hasher.combine(amount.hashValue)
        hasher.combine(receivedAmount.hashValue)
        hasher.combine(date.hashValue)
    }

    enum CodingKeys: String, CodingKey {
        case source
        case target
        case description
        case amount
        case receivedAmount
        case date
    }
}
