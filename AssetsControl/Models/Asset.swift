//
//  Models.swift
//  My Assets
//
//  Created by Igoryok
//

import SwiftUI

class Asset: Comparable, Identifiable, Codable {
    private var prevValue: Double
    private var prevDate: Date

    let id = UUID()

    @Published var name: String
    @Published var symbol: Symbol
    @Published var color: Color
    @Published var isLiquid: Bool
    @Published var compoundFrequency: CompoundFrequency
    @Published var annualInterestFraction: Double

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

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        name = try values.decode(String.self, forKey: .name)
        symbol = try values.decode(Symbol.self, forKey: .symbol)
        color = try values.decode(Color.self, forKey: .color)
        isLiquid = try values.decode(Bool.self, forKey: .isLiquid)
        compoundFrequency = try values.decode(CompoundFrequency.self, forKey: .compoundFrequency)
        annualInterestFraction = try values.decode(Double.self, forKey: .annualInterestFraction)
        prevValue = try values.decode(Double.self, forKey: .prevValue)
        prevDate = try values.decode(Date.self, forKey: .prevDate)
    }

    static func == (lhs: Asset, rhs: Asset) -> Bool {
        lhs.currentValue == rhs.currentValue
    }

    static func < (lhs: Asset, rhs: Asset) -> Bool {
        lhs.currentValue < rhs.currentValue
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(name, forKey: .name)
        try container.encode(symbol, forKey: .symbol)
        try container.encode(color, forKey: .color)
        try container.encode(isLiquid, forKey: .isLiquid)
        try container.encode(compoundFrequency, forKey: .compoundFrequency)
        try container.encode(annualInterestFraction, forKey: .annualInterestFraction)
        try container.encode(prevValue, forKey: .prevValue)
        try container.encode(prevDate, forKey: .prevDate)
    }

    func currentValue(at date: Date) -> Double {
        let periodsSinceDate = date.timeIntervalSince(prevDate) / compoundFrequency.timeInterval
        return prevValue * pow(1 + (annualInterestFraction / compoundFrequency.periodsPerYear), periodsSinceDate)
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
