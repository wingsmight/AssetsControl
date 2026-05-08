//
//  ExpensesPDFParser.swift
//  AssetsControl
//

import Foundation
import PDFKit

// MARK: - Source

enum ExpensesPDFSource: String, CaseIterable, Identifiable, Codable, Hashable {
    case jusan

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .jusan: return "Jusan Bank"
        }
    }

    var shortHint: String {
        switch self {
        case .jusan: return "Statement export from Jusan / Alatau app"
        }
    }
}

// MARK: - Protocol

protocol ExpensesPDFParser {
    /// Stable identifier used in UI and persistence.
    var source: ExpensesPDFSource { get }

    /// Heuristic: returns `true` if this PDF looks like a document this parser knows how to read.
    func canParse(_ document: PDFDocument) -> Bool

    /// Parse expenses out of the given PDF file URL.
    func parseExpenses(from url: URL, moneyHolder: MoneyHolder) throws -> [Expense]
}

extension ExpensesPDFParser {
    func canParse(_ url: URL) -> Bool {
        guard let document = PDFDocument(url: url) else { return false }
        return canParse(document)
    }
}

// MARK: - Registry

struct ExpensesPDFParserRegistry {
    static let `default` = ExpensesPDFParserRegistry(parsers: [
        JusanPDFParser()
    ])

    let parsers: [ExpensesPDFParser]

    var availableSources: [ExpensesPDFSource] {
        parsers.map(\.source)
    }

    func parser(for source: ExpensesPDFSource) -> ExpensesPDFParser? {
        parsers.first(where: { $0.source == source })
    }

    /// Pick the first parser whose `canParse` returns true. Falls back to `nil`.
    func autoDetectParser(for url: URL) throws -> ExpensesPDFParser? {
        guard let document = PDFDocument(url: url) else {
            throw ParserError.failedToOpenPDF
        }
        return parsers.first(where: { $0.canParse(document) })
    }
}

// MARK: - Errors

enum ParserError: Error, LocalizedError {
    case failedToOpenPDF
    case unsupportedFormat

    var errorDescription: String? {
        switch self {
        case .failedToOpenPDF:
            return "Could not open this file as a PDF."
        case .unsupportedFormat:
            return "This PDF format is not supported yet."
        }
    }
}
