//
//  Debt.swift
//  AssetsControl
//
//  Created by Igoryok on 28.03.2023.
//

import SwiftUI

class Debt: Comparable, Identifiable, Codable {
    let id = UUID()

    var name: String
    var symbol: Symbol
    var color: Color

    var annualInterestFraction: Double
    var monthlyPayment: Double

    private var prevValue: Double
    private var prevDate: Date

    init() {
        name = ""
        symbol = Symbol.defaultSymbol
        color = .black
        annualInterestFraction = 0
        monthlyPayment = 0
        prevValue = 0
        prevDate = Date()
    }

    static func == (lhs: Debt, rhs: Debt) -> Bool {
        lhs.currentValue == rhs.currentValue
    }

    static func < (lhs: Debt, rhs: Debt) -> Bool {
        lhs.currentValue < rhs.currentValue
    }

    func currentValue(at date: Date) -> Double {
        let monthsSinceDate = date.timeIntervalSince(prevDate) / TimeInterval.month
        let monthlyInterestRate = annualInterestFraction / 12
        let compoundFactor = pow(1 + monthlyInterestRate, monthsSinceDate)
        let value = prevValue * compoundFactor - (monthlyPayment / monthlyInterestRate) * (compoundFactor - 1)
        return max(0, value)
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
