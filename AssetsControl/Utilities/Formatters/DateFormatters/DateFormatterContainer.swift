//
//  DateFormatterContainer.swift
//  Splus
//
//  Created by Igoryok on 12.02.2023.
//

import Foundation

class DateFormatterContainer {
    static var stackDateFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"

        return formatter
    }

    static var dayOfMonth: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"

        return formatter
    }

    static var timeOfDay: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        return formatter
    }

    static var dayTime: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"

        return formatter
    }
}
