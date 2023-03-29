//
//  StringFormatterContainer.swift
//  Splus
//
//  Created by Igoryok on 14.03.2023.
//

import Foundation

class StringFormatterContainer {
    static var rubMoney: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        
        return formatter
    }
}
