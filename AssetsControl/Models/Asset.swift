//
//  Models.swift
//  My Assets
//
//  Created by Igoryok
//

import SwiftUI

struct Asset: Comparable, Identifiable, Codable {
    private var prevValue: Double
    private var prevDate: Date

    var name: String
    var symbol: Symbol
    var color: Color
    var isLiquid: Bool
    var compoundFrequency: CompoundFrequency
    var annualInterestFraction: Double

    init() {
        name = ""
        symbol = Symbol.defaultSymbol
        color = .black
        isLiquid = true
        compoundFrequency = .none
        annualInterestFraction = 0
        prevValue = 0
        prevDate = Date()
    }

    init(stock: Stock) {
        name = stock.symbol
        symbol = Symbol.stocks
        color = .black
        isLiquid = true
        compoundFrequency = .none
        annualInterestFraction = stock.annualInterestFraction ?? 0.0
        prevValue = stock.price ?? 0.00 * Double(stock.numberOfShares)
        prevDate = Date()
    }

    // For legacy decode
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        name = try values.decode(String.self, forKey: .name)
        symbol = try values.decode(Symbol.self, forKey: .symbol)
        color = try values.decode(Color.self, forKey: .color)
        isLiquid = (try? values.decode(Bool.self, forKey: .isLiquid)) ?? true
        compoundFrequency = (try? values.decode(CompoundFrequency.self, forKey: .compoundFrequency)) ?? .none
        annualInterestFraction = try values.decode(Double.self, forKey: .annualInterestFraction)
        prevValue = try values.decode(Double.self, forKey: .prevValue)
        prevDate = try values.decode(Date.self, forKey: .prevDate)
    }

    static func < (lhs: Asset, rhs: Asset) -> Bool {
        lhs.currentValue < rhs.currentValue
    }

    func currentValue(at date: Date) -> Double {
        let periodsSinceDate = date.timeIntervalSince(prevDate) / compoundFrequency.timeInterval
        return prevValue * pow(1 + (annualInterestFraction / compoundFrequency.periodsPerYear), periodsSinceDate)
    }

    var id: String {
        name
    }

    var effectiveAnnualInterestFraction: Double {
        if compoundFrequency.timeInterval == .year {
            return annualInterestFraction
        } else {
            return pow(1 + (annualInterestFraction / compoundFrequency.periodsPerYear), compoundFrequency.periodsPerYear) - 1
        }
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

    var monthlyEarnings: Double {
        (currentValue * pow(1 + annualInterestFraction / 12, 1)) - currentValue
    }

    enum CompoundFrequency: String, CaseIterable, Identifiable, Codable {
        case yearly
        case monthly
        case biweekly
        case none

        var id: Self { self }
        var timeInterval: TimeInterval {
            switch self {
            case .monthly:
                return .month
            case .biweekly:
                return .month / 2
            case .yearly, .none:
                return .year
            }
        }

        var periodsPerYear: Double {
            TimeInterval.year / timeInterval
        }
    }

    enum CodingKeys: String, CodingKey {
        case name
        case symbol
        case color
        case isLiquid
        case compoundFrequency
        case annualInterestFraction
        case prevValue
        case prevDate
    }
}
