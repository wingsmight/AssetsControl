//
//  Day.swift
//  Splus
//
//  Created by Igoryok on 20.02.2023.
//

import Foundation

final class Day: Comparable, Equatable, Identifiable, Strideable, Hashable, CustomStringConvertible {
    let date: Date

    convenience init() {
        self.init(Date())
    }

    init(_ date: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)

        self.date = calendar.date(from: components)!
    }

    func advanced(by dayCount: Int) -> Day {
        Day(Calendar.current.date(byAdding: .day, value: dayCount, to: date)!)
    }

    func distance(to otherDay: Day) -> Int {
        Calendar.current.dateComponents([.day], from: date, to: otherDay.date).day!
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(date)
    }

    static func == (lhs: Day, rhs: Day) -> Bool {
        Calendar.current.dateComponents([.day], from: lhs.date, to: rhs.date).day == 0
    }

    static func < (lhs: Day, rhs: Day) -> Bool {
        lhs.date < rhs.date
    }

    static func <= (lhs: Day, rhs: Day) -> Bool {
        lhs.date <= rhs.date
    }

    static func >= (lhs: Day, rhs: Day) -> Bool {
        lhs.date >= rhs.date
    }

    static func > (lhs: Day, rhs: Day) -> Bool {
        lhs.date > rhs.date
    }

    var description: String {
        date.dayString ?? date.description
    }
}

extension Date {
    var day: Day {
        get {
            Day(self)
        }
        set {
            let calendar = Calendar.current
            var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
            components.day = calendar.dateComponents([.day], from: newValue.date).day

            self = calendar.date(from: components)!
        }
    }
}
