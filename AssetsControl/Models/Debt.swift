//
//  Debt.swift
//  AssetsControl
//
//  Created by Igoryok on 28.03.2023.
//

import Foundation

struct Debt: Comparable, Identifiable, Codable {
    var name: String
    var symbol: Symbol
    var colorHex: String

    var annualInterestFraction: Double
    var monthlyPayment: Double

    private var prevValue: Double
    private var prevDate: Date

    init() {
        name = ""
        symbol = Symbol.defaultSymbol
        colorHex = "000000"
        annualInterestFraction = 0
        monthlyPayment = 0
        prevValue = 0
        prevDate = Date()
    }

    static func < (lhs: Debt, rhs: Debt) -> Bool {
        lhs.currentValue < rhs.currentValue
    }
    
    func currentValue(at date: Date) -> Double {
        let monthsSinceDate = date.timeIntervalSince(prevDate) / TimeInterval.month
        let i = annualInterestFraction / 12
        let value = prevValue * pow(1 + i, monthsSinceDate) - (monthlyPayment / i) * (pow(1 + i, monthsSinceDate) - 1)
        return max(0, value)
    }

    var id: String {
        name
    }

    var currentValue: Double {
        get {
            currentValue(at: Date())
        }
        set {
            prevValue = newValue
            prevDate = Date()
        }
    }
}
