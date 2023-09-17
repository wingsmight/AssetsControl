//
//  IncomeSource.swift
//  AssetsControl
//
//  Created by Igoryok on 08.09.2023.
//

import Foundation

class IncomeSource: Codable, Identifiable, Hashable {
    let id = UUID()

    @Published var name: String
    @Published var description: String
    @Published var currency: Currency

    init(name: String,
         description: String = "",
         currency: Currency)
    {
        self.name = name
        self.description = description
        self.currency = currency
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        name = try values.decode(String.self, forKey: .name)
        description = try values.decode(String.self, forKey: .description)
        currency = try values.decodeIfPresent(Currency.self, forKey: .currency) ?? .dollar
    }

    static func == (lhs: IncomeSource, rhs: IncomeSource) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(description)
        hasher.combine(currency)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(currency, forKey: .currency)
    }

    enum CodingKeys: String, CodingKey {
        case name
        case description
        case currency
    }
}
