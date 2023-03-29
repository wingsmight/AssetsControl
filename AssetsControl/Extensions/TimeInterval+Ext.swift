//
//  TimeInterval+Ext.swift
//
//  Created by Igoryok
//

import Foundation

extension TimeInterval {
    static func hour(count: Int) -> TimeInterval {
        hour * Double(count)
    }

    static var minute = TimeInterval(60)
    static var twoMinute = TimeInterval(60)

    static var hour = TimeInterval(minute * 60)
    static var twoHour: TimeInterval = (hour * 2)

    static var day: TimeInterval = (hour * 24)
    static var twoDays: TimeInterval = (day * 2)

    static var week: TimeInterval = (day * 7)
    static var twoWeek: TimeInterval = (week * 2)

    static var month: TimeInterval = (day * 30)

    static let year: TimeInterval = (day * 365)
}
