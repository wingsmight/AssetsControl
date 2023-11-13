//
//  UserData.swift
//  AssetsControl
//
//  Created by Igoryok on 03.01.2024.
//

import SwiftUI

struct UserData: Codable {
    private(set) var lastMoneyHolderSource: MoneyHolder?

    init() {}

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        lastMoneyHolderSource = try container.decodeIfPresent(MoneyHolder.self,
                                                        forKey: .lastMoneyHolder)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(lastMoneyHolderSource, forKey: .lastMoneyHolder)
    }

    enum CodingKeys: String, CodingKey {
        case lastMoneyHolder
    }
}

extension UserData {
    mutating func setLastMoneyHolderSource(_ lastMoneyHolderSource: MoneyHolder?) {
        self.lastMoneyHolderSource = lastMoneyHolderSource
    }
}
