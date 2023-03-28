//
//  String+Ext.swift
//  Splus
//
//  Created by Igoryok on 21.02.2023.
//

import Foundation

extension String {
    func nonNumericRemoved() -> String {
        let regex = try! NSRegularExpression(pattern: "[^0-9]")
        return regex.stringByReplacingMatches(in: self, options: [], range: NSRange(location: 0, length: utf16.count), withTemplate: "")
    }

    var capitalizedSentence: String {
        let firstLetter = prefix(1).capitalized
        let remainingLetters = dropFirst().lowercased()
        return firstLetter + remainingLetters
    }

    subscript(range: Range<Int>) -> String? {
        guard range.lowerBound >= 0, range.upperBound <= count else {
            return nil
        }
        let startIndex = index(startIndex, offsetBy: range.lowerBound)
        let endIndex = index(startIndex, offsetBy: range.upperBound - range.lowerBound)
        return String(self[startIndex..<endIndex])
    }
}
