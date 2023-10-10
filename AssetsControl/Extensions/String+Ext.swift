//
//  String+Ext.swift
//
//  Created by Igoryok
//

import Foundation

extension String {
    func nonNumericRemoved() -> String {
        guard let regex = try? NSRegularExpression(pattern: "[^0-9]") else {
            return self
        }
        let range = NSRange(location: 0, length: utf16.count)
        return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
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

    func removingExceptFirst(_ subString: any StringProtocol) -> String {
        var result = self
        result.removeExceptFirst(subString)

        return result
    }

    mutating func removeExceptFirst(_ subString: any StringProtocol) {
        guard let firstCommaRange = range(of: subString) else {
            return
        }

        let firstPart = self[..<firstCommaRange.upperBound]
        let secondPart = self[firstCommaRange.upperBound...]
            .replacingOccurrences(of: subString, with: "")

        self = "\(firstPart)\(secondPart)"
    }

    func removingLeadingZero() -> String {
        var result = self
        result.removeLeadingZero()

        return result
    }

    mutating func removeLeadingZero() {
        while first == "0",
              count > 1
        {
            removeFirst()
        }
    }
}
