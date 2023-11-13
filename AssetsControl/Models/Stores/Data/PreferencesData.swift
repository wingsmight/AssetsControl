//
//  PreferencesData.swift
//  AssetsControl
//
//  Created by Igoryok on 03.01.2024.
//

import SwiftUI

struct PreferencesData: Codable {
    private(set) var defaultMoneyHolderSourceMethod: DefaultMoneyHolderSourceMethod

    init() {
        defaultMoneyHolderSourceMethod = .lastUsed
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        defaultMoneyHolderSourceMethod = try container
            .decodeIfPresent(DefaultMoneyHolderSourceMethod.self,
                             forKey: .defaultMoneyHolderSourceMethod) ?? .lastUsed
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(defaultMoneyHolderSourceMethod, forKey: .defaultMoneyHolderSourceMethod)
    }

    enum CodingKeys: String, CodingKey {
        case defaultMoneyHolderSourceMethod
    }
}
