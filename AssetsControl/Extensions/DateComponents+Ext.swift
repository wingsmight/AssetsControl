//
//  DateComponents+Ext.swift
//  Splus
//
//  Created by Igoryok on 16.02.2023.
//

import Foundation

extension DateComponents {
    static let secondsInMinute = 60
    static let minutesInHour = 60
    static let hoursInDay = 24

    var totalMinutes: Int {
        var value = 0

        if let minutes = minute {
            value += minutes
        }

        if let hours = hour {
            value += hours * Self.minutesInHour
        }

        if let days = day {
            value += days * Self.hoursInDay * Self.minutesInHour
        }

        return value
    }

    var totalSeconds: Double {
        var value: Double = 0.0

        if let seconds = second {
            value += Double(seconds)
        }

        if let minutes = minute {
            value += Double(minutes * Self.secondsInMinute)
        }

        if let hours = hour {
            value += Double(hours * Self.minutesInHour * Self.secondsInMinute)
        }

        if let days = day {
            value += Double(days) * Double(Self.hoursInDay * Self.minutesInHour * Self.secondsInMinute)
        }

        return value
    }
}
