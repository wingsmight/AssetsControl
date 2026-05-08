import Foundation
import PDFKit
import SwiftUI

final class JusanPDFParser: ExpensesPDFParser {

    let source: ExpensesPDFSource = .jusan

    private enum RegexStorage {
        /// Full datetime on one line (older statements, some PDF extractions).
        static let legacyDateTimeRegex: NSRegularExpression? = {
            try? NSRegularExpression(
                pattern: #"\d{2}\.\d{2}\.\d{4}\s+\d{2}:\d{2}:\d{2}"#
            )
        }()

        static let leadingDateRegex: NSRegularExpression? = {
            try? NSRegularExpression(
                pattern: #"^\s*(\d{2}\.\d{2}\.\d{4})\b"#
            )
        }()

        static let leadingTimeRegex: NSRegularExpression? = {
            try? NSRegularExpression(
                pattern: #"^\s*(\d{2}:\d{2}:\d{2})\b"#
            )
        }()

        /// Trailing "CCY 0 <amount in KZT>" on card / multi-currency lines (Jusan / Alatau PDF).
        static let statementSettlementRegex: NSRegularExpression? = {
            try? NSRegularExpression(
                pattern: #"(KZT|KRW|USD|EUR|RUB)\s+0\s+(\d[\d\s,]*(?:\.\d+)?)\s*$"#
            )
        }()

        static let amountRegex: NSRegularExpression? = {
            try? NSRegularExpression(
                pattern: #"(\d[\d\s]*\.\d+|\d[\d\s]*)$"#
            )
        }()
    }

    public init() {}

    // MARK: - Public API

    func canParse(_ document: PDFDocument) -> Bool {
        let text = extractText(from: document)
        let normalised = text.lowercased()

        if normalised.contains("jusan") { return true }
        if normalised.contains("alatau") { return true }
        if text.contains("Покупка") { return true }

        let lines = text.components(separatedBy: .newlines)
        return lines.contains { parseStatementSettlement(from: $0.trimmingCharacters(in: .whitespacesAndNewlines)) != nil }
    }

    func parseExpenses(
        from url: URL,
        moneyHolder: MoneyHolder
    ) throws -> [Expense] {

        guard let document = PDFDocument(url: url) else {
            throw ParserError.failedToOpenPDF
        }

        let fullText = extractText(from: document)
        let lines = fullText.components(separatedBy: .newlines)

        return parseLines(lines, moneyHolder: moneyHolder)
    }
}

// MARK: - Parsing

private extension JusanPDFParser {

    func extractText(from document: PDFDocument) -> String {
        var text = ""

        for pageIndex in 0..<document.pageCount {
            if let page = document.page(at: pageIndex),
               let pageText = page.string {
                text += pageText + "\n"
            }
        }

        return text
    }

    func parseLines(
        _ lines: [String],
        moneyHolder: MoneyHolder
    ) -> [Expense] {

        var expenses: [Expense] = []

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Almaty")

        for lineIndex in 0..<lines.count {

            let rawLine = lines[lineIndex]
            let line = rawLine.trimmingCharacters(in: .whitespacesAndNewlines)

            if line.isEmpty { continue }

            if isTimeOnlyLine(line) {
                continue
            }

            // Legacy: "Покупка …" with amount in following lines (KZT-focused heuristic).
            if line.contains("Покупка") {
                let name = extractPurchaseName(from: line)
                let amount = extractAmount(from: lines, index: lineIndex)
                guard let amount else { continue }
                guard let date = resolveDateForLine(
                    lineIndex: lineIndex,
                    line: rawLine,
                    lines: lines,
                    dateFormatter: dateFormatter
                ) else { continue }

                expenses.append(
                    Expense(
                        name: name,
                        symbol: .banknote,
                        amount: amount,
                        moneyHolderSource: moneyHolder,
                        date: date
                    )
                )
                continue
            }

            // Jusan / Alatau card statement: merchant + "KRW 0 12 345.67" (last number is KZT booking).
            guard let settlement = parseStatementSettlement(from: line) else { continue }
            guard let date = resolveDateForLine(
                lineIndex: lineIndex,
                line: rawLine,
                lines: lines,
                dateFormatter: dateFormatter
            ) else { continue }

            let name = extractMerchantName(from: line, settlementRange: settlement.fullMatchRange)
            guard !name.isEmpty else { continue }

            expenses.append(
                Expense(
                    name: name,
                    symbol: .banknote,
                    amount: Money(settlement.kztAmount, of: .tenge),
                    moneyHolderSource: moneyHolder,
                    date: date
                )
            )
        }

        return expenses
    }
}

// MARK: - Statement row model

private struct StatementSettlement {
    let fullMatchRange: NSRange
    let kztAmount: Double
}

// MARK: - Helpers

private extension JusanPDFParser {

    func isTimeOnlyLine(_ trimmedLine: String) -> Bool {
        guard let regex = RegexStorage.leadingTimeRegex,
              let match = regex.firstMatch(
                in: trimmedLine,
                range: NSRange(trimmedLine.startIndex..., in: trimmedLine)
              )
        else { return false }

        let remainderStart = match.range.location + match.range.length
        guard remainderStart <= trimmedLine.utf16.count else { return true }
        let remainder = (trimmedLine as NSString).substring(from: remainderStart)
        return remainder.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func parseStatementSettlement(from line: String) -> StatementSettlement? {
        guard let regex = RegexStorage.statementSettlementRegex else { return nil }

        let nsLine = line as NSString
        let full = nsLine.length
        guard let match = regex.firstMatch(in: line, range: NSRange(location: 0, length: full)) else {
            return nil
        }

        let rawAmount = nsLine.substring(with: match.range(at: 2))
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ",", with: ".")

        guard let value = Double(rawAmount), value > 0 else { return nil }

        return StatementSettlement(fullMatchRange: match.range, kztAmount: value)
    }

    func extractMerchantName(from line: String, settlementRange: NSRange) -> String {
        let nsLine = line as NSString
        let prefixEnd = min(settlementRange.location, nsLine.length)
        var work = nsLine.substring(to: prefixEnd)

        if let (_, end) = leadingDatePrefix(in: work) {
            work = substring(work, fromUTF16: end)
        }

        if let (_, end) = leadingTimePrefix(in: work) {
            work = substring(work, fromUTF16: end)
        }

        work = work
            .replacingOccurrences(of: #"\s*:\s*\d+\s*"#, with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)

        while work.hasPrefix(":") {
            work = String(work.dropFirst()).trimmingCharacters(in: .whitespacesAndNewlines)
        }

        work = work.replacingOccurrences(of: #"\s+"#, with: " ", options: .regularExpression)
        return work.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func resolveDateForLine(
        lineIndex: Int,
        line: String,
        lines: [String],
        dateFormatter: DateFormatter
    ) -> Date? {
        let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)

        if let legacy = RegexStorage.legacyDateTimeRegex,
           let legacyMatch = legacy.firstMatch(in: trimmed, range: NSRange(trimmed.startIndex..., in: trimmed)) {
            let legacyText = (trimmed as NSString).substring(with: legacyMatch.range)
            if let parsedDate = dateFormatter.date(from: legacyText) { return parsedDate }
        }

        if let (dateStr, dateConsumedEnd) = leadingDatePrefix(in: trimmed) {
            let afterDate = substring(trimmed, fromUTF16: dateConsumedEnd)
                .trimmingCharacters(in: .whitespacesAndNewlines)

            if let (timeStr, _) = leadingTimePrefix(in: afterDate) {
                return dateFormatter.date(from: "\(dateStr) \(timeStr)")
            }

            if lineIndex + 1 < lines.count {
                let nextRaw = lines[lineIndex + 1]
                let nextTrim = nextRaw.trimmingCharacters(in: .whitespacesAndNewlines)
                if let (timeStr, _) = leadingTimePrefix(in: nextTrim) {
                    return dateFormatter.date(from: "\(dateStr) \(timeStr)")
                }
            }

            return nil
        }

        if let (timeStr, timeConsumedEnd) = leadingTimePrefix(in: trimmed) {
            let afterTime = substring(trimmed, fromUTF16: timeConsumedEnd)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            guard !afterTime.isEmpty else { return nil }

            var priorLineIndex = lineIndex - 1
            while priorLineIndex >= 0 {
                let prevTrim = lines[priorLineIndex].trimmingCharacters(in: .whitespacesAndNewlines)
                if let (dateStr, dateConsumedEnd) = leadingDatePrefix(in: prevTrim) {
                    let afterDate = substring(prevTrim, fromUTF16: dateConsumedEnd)
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                    if leadingTimePrefix(in: afterDate) == nil {
                        return dateFormatter.date(from: "\(dateStr) \(timeStr)")
                    }
                }
                priorLineIndex -= 1
            }
        }

        // Continuation line: amount at the end, date and time on earlier rows (see Jusan PDF layout).
        if parseStatementSettlement(from: trimmed) != nil,
           leadingDatePrefix(in: trimmed) == nil,
           leadingTimePrefix(in: trimmed) == nil {

            var foundTime: String?
            var timeLookbackIndex = lineIndex - 1
            while timeLookbackIndex >= 0 {
                let prev = lines[timeLookbackIndex].trimmingCharacters(in: .whitespacesAndNewlines)
                if parseStatementSettlement(from: prev) != nil { break }
                if let (timeStr, _) = leadingTimePrefix(in: prev) {
                    foundTime = timeStr
                    break
                }
                timeLookbackIndex -= 1
            }

            if let timeStr = foundTime {
                var dateLookbackIndex = lineIndex - 1
                while dateLookbackIndex >= 0 {
                    let prev = lines[dateLookbackIndex].trimmingCharacters(in: .whitespacesAndNewlines)
                    if let (dateStr, dateConsumedEnd) = leadingDatePrefix(in: prev) {
                        let afterDate = substring(prev, fromUTF16: dateConsumedEnd)
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                        if leadingTimePrefix(in: afterDate) == nil {
                            return dateFormatter.date(from: "\(dateStr) \(timeStr)")
                        }
                    }
                    dateLookbackIndex -= 1
                }
            }
        }

        return nil
    }

    /// Date token and UTF-16 offset in `line` right after the full leading-date match (incl. leading spaces).
    func leadingDatePrefix(in line: String) -> (String, endUTF16: Int)? {
        guard let regex = RegexStorage.leadingDateRegex,
              let dateMatch = regex.firstMatch(in: line, range: NSRange(line.startIndex..., in: line)),
              dateMatch.numberOfRanges >= 2
        else { return nil }

        let dateStr = (line as NSString).substring(with: dateMatch.range(at: 1))
        let end = dateMatch.range.location + dateMatch.range.length
        return (dateStr, end)
    }

    /// Time token and UTF-16 offset after the full leading-time match (incl. leading spaces).
    func leadingTimePrefix(in line: String) -> (String, endUTF16: Int)? {
        guard let regex = RegexStorage.leadingTimeRegex,
              let timeMatch = regex.firstMatch(in: line, range: NSRange(line.startIndex..., in: line)),
              timeMatch.numberOfRanges >= 2
        else { return nil }

        let timeStr = (line as NSString).substring(with: timeMatch.range(at: 1))
        let end = timeMatch.range.location + timeMatch.range.length
        return (timeStr, end)
    }

    /// UTF-16 offset from start of string (matches NSString indexing).
    func substring(_ string: String, fromUTF16 offset: Int) -> String {
        let nsString = string as NSString
        guard offset >= 0, offset <= nsString.length else { return "" }
        return nsString.substring(from: offset)
    }

    func extractPurchaseName(from line: String) -> String {
        line
            .replacingOccurrences(of: "Покупка", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func extractAmount(from lines: [String], index: Int) -> Money? {
        for offset in 0...3 {
            let lineIndex = index + offset
            guard lineIndex < lines.count else { break }

            let line = lines[lineIndex]

            if let settlement = parseStatementSettlement(from: line) {
                return Money(settlement.kztAmount, of: .tenge)
            }

            if let amount = parseKZTAmount(from: line) {
                return amount
            }
        }

        return nil
    }

    func parseKZTAmount(from line: String) -> Money? {

        guard let regex = RegexStorage.amountRegex else { return nil }

        guard let match = regex.firstMatch(
            in: line,
            range: NSRange(line.startIndex..., in: line)
        ) else { return nil }

        let raw = (line as NSString).substring(with: match.range)
            .replacingOccurrences(of: " ", with: "")

        guard let value = Double(raw) else { return nil }

        return Money(value, of: .tenge)
    }
}

