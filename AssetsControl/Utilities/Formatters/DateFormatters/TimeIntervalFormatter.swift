//
//  TimeIntervalFormatter.swift
//  Splus
//
//  Created by Igoryok on 21.02.2023.
//

import Foundation

struct TimeIntervalFormatter {
    static let shared = TimeIntervalFormatter()

    private let formatter: DateComponentsFormatter

    private init() {
        formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
    }

    func string(from timeInterval: TimeInterval) -> String {
        guard timeInterval > 0 else {
            return "00:00"
        }
        
        if Int(timeInterval) >= DateComponents(hour: 1).totalMinutes {
            formatter.allowedUnits = [.hour, .minute, .second]
        } else {
            formatter.allowedUnits = [.minute, .second]
        }
        
        return formatter.string(from: timeInterval)!
    }
}
