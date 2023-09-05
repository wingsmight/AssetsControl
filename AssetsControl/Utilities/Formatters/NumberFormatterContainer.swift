//
//  NumberFormatterContainer.swift
//  AssetsControl
//
//  Created by Igoryok on 28.03.2023.
//

import Foundation

class NumberFormatterContainer {
    static let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()

        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2

        return formatter
    }()
    
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()

        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2

        return formatter
    }()

    static let currencyDeltaFormatter: NumberFormatter = {
        let formatter = NumberFormatter()

        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.positivePrefix = "+"

        return formatter
    }()

    static let percentFormatter: NumberFormatter = {
        let formatter = NumberFormatter()

        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1

        return formatter
    }()
}
