//
//  Income.swift
//  AssetsControl
//
//  Created by Igoryok
//

import SwiftUI

protocol Income: Hashable, Identifiable, Codable {
    var id: UUID { get }

    var name: String { get set }
    var symbol: Symbol { get set }
    var initialDate: Date { get set }
    var source: IncomeSource { get set }
    var target: MoneyHolder { get set }
}

extension Income {
    static func == (lhs: any Income, rhs: any Income) -> Bool {
        lhs.id == rhs.id
    }
}
