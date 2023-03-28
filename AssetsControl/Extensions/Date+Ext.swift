//
//  Date+Ext.swift
//  Splus
//
//  Created by Igoryok on 12.02.2023.
//

import Foundation

extension Date {
    init?(from string: String, with format: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format

        if let date = dateFormatter.date(from: string) {
            self = date
        } else {
            return nil
        }
    }

    func dayNumberOfWeek() -> Int? {
        Calendar.current.dateComponents([.weekday], from: self).weekday
    }

    func dayOfWeek(_ length: FormatLength = .full) -> String? {
        let dateFormatter = DateFormatter()

        switch length {
        case .short:
            dateFormatter.dateFormat = "EE"
        case .full:
            dateFormatter.dateFormat = "EEEE"
        }

        return dateFormatter.string(from: self).capitalized
    }

    var dayString: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"

        return dateFormatter.string(from: self)
    }

    var timeString: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        return dateFormatter.string(from: self)
    }

    enum FormatLength {
        case short
        case full
    }
}

extension Date: Strideable {
    public func distance(to other: Date) -> TimeInterval {
        other.timeIntervalSinceReferenceDate - timeIntervalSinceReferenceDate
    }

    public func advanced(by n: TimeInterval) -> Date {
        self + n
    }
}

extension Date {
    static func from(day: Day, time: Time) -> Date? {
        Calendar.current.date(bySettingTime: time, of: day.date)
    }
}
