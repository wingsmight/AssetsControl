//
//  Currency.swift
//  Splus
//
//  Created by Igoryok on 21.01.2023.
//

import Foundation

enum Currency: String, CaseIterable, CustomStringConvertible, Identifiable, Hashable, Codable {
    case ruble

    var description: String {
        switch self {
        case .ruble: return "Ruble"
        }
    }

    var id: Self { self }

    var symbol: String {
        switch self {
        case .ruble: return "₽"
        }
    }
}
