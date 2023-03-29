//
//  Time.swift
//  EnglishApp
//
//  Created by Igoryok on 04.12.2021.
//

import Foundation

final class Time: Comparable, Equatable, Identifiable, Strideable, Hashable, CustomStringConvertible {
    let hour: Int
    let minute: Int

    init(minutesSinceBeginningOfDay: Int) {
        self.minutesSinceBeginningOfDay = minutesSinceBeginningOfDay

        let minutesInHour = DateComponents(hour: 1).totalMinutes

        hour = (minutesSinceBeginningOfDay / minutesInHour) % minutesInHour
        minute = minutesSinceBeginningOfDay % minutesInHour
    }

    convenience init() {
        self.init(Date())
    }

    convenience init(_ date: Date) {
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)

        let minutesSinceBeginningOfDay = (dateComponents.hour! * DateComponents(hour: 1).totalMinutes) + dateComponents.minute!

        self.init(minutesSinceBeginningOfDay: minutesSinceBeginningOfDay)
    }

    convenience init(_ hour: Int, _ minute: Int) {
        let minutesSinceBeginningOfDay = (hour * DateComponents(hour: 1).totalMinutes) + minute

        self.init(minutesSinceBeginningOfDay: minutesSinceBeginningOfDay)
    }

    static func == (lhs: Time, rhs: Time) -> Bool {
        lhs.minutesSinceBeginningOfDay == rhs.minutesSinceBeginningOfDay
    }

    static func < (lhs: Time, rhs: Time) -> Bool {
        lhs.minutesSinceBeginningOfDay < rhs.minutesSinceBeginningOfDay
    }

    static func <= (lhs: Time, rhs: Time) -> Bool {
        lhs.minutesSinceBeginningOfDay <= rhs.minutesSinceBeginningOfDay
    }

    static func >= (lhs: Time, rhs: Time) -> Bool {
        lhs.minutesSinceBeginningOfDay >= rhs.minutesSinceBeginningOfDay
    }

    static func > (lhs: Time, rhs: Time) -> Bool {
        lhs.minutesSinceBeginningOfDay > rhs.minutesSinceBeginningOfDay
    }

    static func + (lhs: Time, rhs: Time) -> Time {
        let minutesSinceBeginningOfDay = lhs.minutesSinceBeginningOfDay + rhs.minutesSinceBeginningOfDay

        return Time(minutesSinceBeginningOfDay: minutesSinceBeginningOfDay)
    }
    
    static func - (lhs: Time, rhs: Time) -> Time {
        let minutesSinceBeginningOfDay = lhs.minutesSinceBeginningOfDay - rhs.minutesSinceBeginningOfDay

        return Time(minutesSinceBeginningOfDay: minutesSinceBeginningOfDay)
    }

    static func += (lhs: inout Time, rhs: Time) {
        let minutesSinceBeginningOfDay = (lhs + rhs).minutesSinceBeginningOfDay

        lhs = Time(minutesSinceBeginningOfDay: minutesSinceBeginningOfDay)
    }

    static func -= (lhs: inout Time, rhs: Time) {
        let minutesSinceBeginningOfDay = (lhs - rhs).minutesSinceBeginningOfDay

        lhs = Time(minutesSinceBeginningOfDay: minutesSinceBeginningOfDay)
    }
    
    func advanced(by seconds: Int) -> Time {
        Time(minutesSinceBeginningOfDay: minutesSinceBeginningOfDay + seconds)
    }

    func distance(to other: Time) -> Int {
        other.minutesSinceBeginningOfDay - minutesSinceBeginningOfDay
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(hour)
        hasher.combine(minute)
    }

    var date: Date {
        Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: Date())!
    }

    var description: String {
        let minusSign = minutesSinceBeginningOfDay < 0 ? "-" : ""
        
        return String(format: "\(minusSign)%02d:%02d", abs(hour), abs(minute))
    }

    static var zero: Time {
        Time(0, 0)
    }

    static var now: Time {
        Time(Date())
    }

    private var minutesSinceBeginningOfDay: Int
}

extension Time: RawRepresentable {
    public var rawValue: String {
        minutesSinceBeginningOfDay.description
    }

    public convenience init?(rawValue: String) {
        guard let minutesSinceBeginningOfDay = Int(rawValue) else { return nil }

        self.init(minutesSinceBeginningOfDay: minutesSinceBeginningOfDay)
    }
}

extension Date {
    var time: Time {
        get {
            Time(self)
        }
        set {
            changeTime(to: newValue)
        }
    }

    mutating func changeTime(to time: Time) {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        components.hour = time.hour
        components.minute = time.minute
        components.second = 0

        self = calendar.date(from: components)!
    }
}

extension Date {
    func isTimeBetweenInterval(from intervalStart: Date, to intervalFinish: Date) -> Bool {
        time >= intervalStart.time && time <= intervalFinish.time
    }

    func isTimeEarlier(than date: Date) -> Bool {
        time < date.time
    }

    func isTimeLater(than date: Date) -> Bool {
        time > date.time
    }
}

extension Calendar {
    func date(bySettingTime time: Time,
              of date: Date,
              matchingPolicy: Calendar.MatchingPolicy = .nextTime,
              repeatedTimePolicy: Calendar.RepeatedTimePolicy = .first,
              direction searchDirection: Calendar.SearchDirection = .forward) -> Date?
    {
        self.date(bySettingHour: time.hour,
                  minute: time.minute,
                  second: 0,
                  of: date,
                  matchingPolicy: matchingPolicy,
                  repeatedTimePolicy: repeatedTimePolicy,
                  direction: searchDirection)
    }

    func dateComponents(from time: Time) -> DateComponents {
        dateComponents([.hour, .minute], from: time.date)
    }
}
