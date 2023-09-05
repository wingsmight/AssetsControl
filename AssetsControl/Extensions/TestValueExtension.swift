//
//  TestValueExtension.swift
//
//  Created by Igoryok
//

import Foundation

extension CountTabBadge {
    static let test = CountTabBadge(count: 11, backgroundColor: .blue)
    static let test2 = CountTabBadge(count: 22, backgroundColor: .yellow)
    static let test3 = CountTabBadge(count: 33, backgroundColor: .green)
}

extension [CountTabBadge] {
    static let test: [CountTabBadge] = [
        CountTabBadge.test,
        CountTabBadge.test2,
        CountTabBadge.test3,
    ]
}

extension [Day: [Time]] {
    private static let startDay = Day()
    private static let finishDay = Day(Calendar.current.date(byAdding: .day, value: 30, to: Date())!)

    private static let startTime = Time(10, 0)
    private static let finishTime = Time(14, 0)

    static var test: [Day: [Time]] {
        var intervals: [Day: [Time]] = [:]

        var day = startDay
        while day <= finishDay {
            intervals[day] = [startTime, finishTime]
            day = day.advanced(by: 1)
        }

        return intervals
    }
}

extension Expense {
    static let test = Expense(name: "Expense",
                              symbol: Symbol.defaultSymbol,
                              monthlyCost: 100.0,
                              moneyHolderSource: MoneyHolder.test)
}

extension MoneyHolder {
    static let test = MoneyHolder(name: "Apple Card",
                                  description: "Credit Card",
                                  symbol: Symbol.creditCard,
                                  money: Money(12000))
}
