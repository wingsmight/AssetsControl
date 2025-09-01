//
//  Date+Ext.swift
//
//  Created by Igoryok
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

    public func advanced(by distance: TimeInterval) -> Date {
        self + distance
    }
}

extension Date {
    static func from(day: Day, time: Time) -> Date? {
        Calendar.current.date(bySettingTime: time, of: day.date)
    }
}

extension Date {
    var startOfMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: Calendar.current.startOfDay(for: self)))!
    }
    
    var endOfMonth: Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth)!
    }
    
    var currentMonthInterval: DateInterval? {
        Calendar.current.dateInterval(of: .month, for: self)
    }
}
