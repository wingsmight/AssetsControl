//
//  DefaultMoneyHolderMethod.swift
//  AssetsControl
//
//  Created by Igoryok on 03.01.2024.
//

enum DefaultMoneyHolderSourceMethod: CaseIterable, Identifiable, Codable, Hashable {
    case lastUsed
    case selected(MoneyHolder?)
    case ai

    var id: Self { self }

    static var allCases: [DefaultMoneyHolderSourceMethod] {
        [.lastUsed, .selected(nil), .ai]
    }
}
