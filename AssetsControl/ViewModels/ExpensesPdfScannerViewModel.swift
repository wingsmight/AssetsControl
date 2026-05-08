//
//  ExpensesPdfScannerViewModel.swift
//  AssetsControl
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

@MainActor
final class ExpensesPdfScannerViewModel: ObservableObject {
    @Published var showPDFImporter = false
    @Published var showConfirmation = false
    @Published var selectedPDFName: String?
    @Published var isProcessing = false
    @Published var parsedExpenses: [ReceiptScannerViewModel.ParsedExpense] = []
    @Published var errorMessage: String?

    /// User-chosen bank/source. `nil` means "auto-detect".
    @Published var selectedSource: ExpensesPDFSource?

    private let parserRegistry: ExpensesPDFParserRegistry

    private var financesStore: FinancialDataStore?
    private var preferencesStore: PreferencesDataStore?
    private var userStore: UserDataStore?

    init(parserRegistry: ExpensesPDFParserRegistry = .default) {
        self.parserRegistry = parserRegistry
    }

    var availableSources: [ExpensesPDFSource] {
        parserRegistry.availableSources
    }

    var showsInitialEmptyState: Bool {
        selectedPDFName == nil && !isProcessing && parsedExpenses.isEmpty && errorMessage == nil
    }

    func configureStores(
        finances: FinancialDataStore,
        preferences: PreferencesDataStore,
        user: UserDataStore
    ) {
        financesStore = finances
        preferencesStore = preferences
        userStore = user
    }

    func openDocumentPicker() {
        showPDFImporter = true
    }

    func reset() {
        selectedPDFName = nil
        parsedExpenses = []
        errorMessage = nil
        isProcessing = false
    }

    func resetAndPickDifferentPDF() {
        reset()
        showPDFImporter = true
    }

    func presentConfirmation() {
        showConfirmation = true
    }

    func handleImporterResult(_ result: Result<[URL], Error>) {
        switch result {
        case .failure(let error):
            errorMessage = error.localizedDescription
        case .success(let urls):
            guard let url = urls.first else { return }
            parsePDF(at: url)
        }
    }

    private func parsePDF(at sourceURL: URL) {
        selectedPDFName = sourceURL.lastPathComponent
        errorMessage = nil
        parsedExpenses = []
        isProcessing = true

        Task { @MainActor in
            await Task.yield()

            let holder = defaultMoneyHolderForParsing()
            let tempURL: URL
            do {
                tempURL = try Self.copyPDFToTemporaryFile(from: sourceURL)
            } catch {
                isProcessing = false
                errorMessage = error.localizedDescription
                return
            }

            defer { try? FileManager.default.removeItem(at: tempURL) }

            do {
                let parser = try resolveParser(for: tempURL)
                let expenses = try parser.parseExpenses(from: tempURL, moneyHolder: holder)
                parsedExpenses = expenses.map {
                    ReceiptScannerViewModel.ParsedExpense(
                        name: $0.name,
                        amount: $0.amount.count,
                        currency: $0.amount.currency,
                        date: $0.date
                    )
                }
            } catch {
                errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            }
            isProcessing = false
        }
    }

    private func resolveParser(for url: URL) throws -> ExpensesPDFParser {
        if let selectedSource,
           let parser = parserRegistry.parser(for: selectedSource) {
            return parser
        }

        if let auto = try parserRegistry.autoDetectParser(for: url) {
            return auto
        }

        throw ParserError.unsupportedFormat
    }

    private func defaultMoneyHolderForParsing() -> MoneyHolder {
        guard let financesStore, let preferencesStore, let userStore else {
            return MoneyHolder.test
        }

        switch preferencesStore.data.defaultMoneyHolderSourceMethod {
        case .selected(let moneyHolder):
            return moneyHolder ?? MoneyHolder.test
        case .ai, .lastUsed:
            let first = financesStore.data.moneyHolders.first
            return userStore.data.lastMoneyHolderSource ?? first ?? MoneyHolder.test
        }
    }

    private nonisolated static func copyPDFToTemporaryFile(from sourceURL: URL) throws -> URL {
        let accessed = sourceURL.startAccessingSecurityScopedResource()
        defer {
            if accessed {
                sourceURL.stopAccessingSecurityScopedResource()
            }
        }

        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("pdf")

        try FileManager.default.copyItem(at: sourceURL, to: tempURL)
        return tempURL
    }
}
