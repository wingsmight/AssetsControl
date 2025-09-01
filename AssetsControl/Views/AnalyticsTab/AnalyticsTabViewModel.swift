//
//  AnalyticsTabViewModel.swift
//  AssetsControl
//
//  Created by Igoryok
//

import Foundation

extension AnalyticsTab {
    @MainActor
    class ViewModel: ObservableObject {
        @Published var charsData: [Double] = []
        @Published var selectedDate: Date = .init() // Tracks the currently selected month

        // Function to return the expenses for the currently selected month
//        func expensesForCurrentMonth(financialData: FinancialData) -> [Currency: Double] {
//            let monthExpenses = financialData.expenses.filter { expense in
//                Calendar.current.isDate(expense.date, equalTo: selectedDate, toGranularity: .month)
//            }
//
//            let currencyExpenses = Dictionary(grouping: monthExpenses, by: { $0.amount.currency })
//                
//            return Dictionary(uniqueKeysWithValues: currencyExpenses.map { (currency: Currency, expenses: [Expense]) in
//                let categoryExpenses = Dictionary(grouping: expenses, by: { $0.symbol })
//                
//                let summaries = summarizeCategoryExpenses(categoryExpenses)
//                
//                return (currency: summaries.map(\.totalAmount.count))
//            })
//        }
        func totalSumForCurrentMonth(financialData: FinancialData) -> [Currency: Double] {
            let monthExpenses = financialData.expenses.filter { expense in
                Calendar.current.isDate(expense.date, equalTo: selectedDate, toGranularity: .month)
            }

            let currencyExpenses = Dictionary(grouping: monthExpenses, by: { $0.amount.currency })
                
            return Dictionary(uniqueKeysWithValues: currencyExpenses.map { (currency: Currency, expenses: [Expense]) in
                return (currency, expenses.map(\.amount.count).reduce(0, +))
            })
        }

        // Function to generate the formatted month and year string for display
        func formattedMonthYearText() -> String {
            let components = Calendar.current.dateComponents([.year, .month], from: selectedDate)
            let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "MMMM"

            let currentYear = Calendar.current.component(.year, from: Date())
            let month = monthFormatter.string(from: selectedDate)
            let year = components.year ?? currentYear

            return (year == currentYear) ? month : "\(month) \(year)"
        }

        // Function to handle swipe gestures for navigating months
        func handleSwipeGesture(direction: SwipeDirection) {
            switch direction {
            case .left:
                selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) ?? Date()
            case .right:
                selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) ?? Date()
            }
        }

        func calculateCharts(financialData: FinancialData) {
            guard let currentMonthInterval = Date().currentMonthInterval else { return }

            let currentMonthExpenses = financialData.expenses.filter { currentMonthInterval.contains($0.date) }
            charsData = currentMonthExpenses.map(\.amount.count)
        }

        private func summarizeCategoryExpenses(_ categoryExpenses: [Symbol: [Expense]]) -> [Summary] {
            var summaries: [Summary] = []
            var symbolMoney: [Symbol: Money] = [:]

            for (symbol, expenses) in categoryExpenses {
                guard let firstExpense = expenses.first else { continue }
                
                symbolMoney[symbol] = Money(0, of: firstExpense.amount.currency)
                
                let moneyHolderExpenses = Dictionary(grouping: expenses, by: { $0.moneyHolderSource })
                
                
//                let exchangeRate = try await withCheckedThrowingContinuation { continuation in
//                    CurrencyExchangeAPI.shared.fetchExchangeRate(from: currentMoney.currency.code.lowercased(),
//                                                                 to: targetCurrencyCode)
//                    { result in
//                        switch result {
//                        case let .success(rate):
//                            continuation.resume(returning: rate)
//                        case let .failure(error):
//                            continuation.resume(throwing: error)
//                        }
//                    }
//                }
                
                // Sum all expenses for the current symbol
                let totalAmount = expenses.reduce(Money(0)) { partialResult, expense in
                    partialResult + expense.amount
                }

                // Create a summary for the symbol and add it to the array
                let summary = Summary(symbol: symbol, totalAmount: totalAmount)
                summaries.append(summary)
            }

            return summaries
        }
    }

    struct Summary {
        var symbol: Symbol
        var totalAmount: Money
    }

    enum SwipeDirection {
        case left, right
    }
}
