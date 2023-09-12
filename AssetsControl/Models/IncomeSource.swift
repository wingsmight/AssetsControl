//
//  IncomeSource.swift
//  AssetsControl
//
//  Created by Igoryok on 08.09.2023.
//

import Foundation

class IncomeSource: Codable, Identifiable, Hashable {
    let id = UUID()

    var name: String
    var description: String

    init(name: String, description: String = "") {
        self.name = name
        self.description = description
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        name = try values.decode(String.self, forKey: .name)
        description = try values.decode(String.self, forKey: .description)
    }

    static func == (lhs: IncomeSource, rhs: IncomeSource) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(description)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
    }

    enum CodingKeys: String, CodingKey {
        case name
        case description
    }
}
