//
//  ExpensesTab.swift
//  AssetsControl
//
//  Created by Igoryok on 28.03.2023.
//

import SwiftUI

struct ExpensesTab: View {
    @EnvironmentObject private var financesStore: FinancialDataStore

    @State private var isNewAssetSheetShowing: Bool = false
    @State private var expense: Expense? = nil

    var body: some View {
        NavigationView {
            List {
                ForEach(expenseGroupHeaders, id: \.self) { headerDate in
                    Section(header: Text(headerDate, style: .date)) {
                        ForEach(expenseGroups[headerDate]!) { expense in
                            ExpenseView(expense: expense)
                        }
                        .onDelete { offsetIndexSet in
                            removeExpenses(at: offsetIndexSet, for: headerDate)
                        }
                    }
                }
            }
            .navigationTitle("Expenses")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isNewAssetSheetShowing = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .foregroundColor(.red)
                }
            }
            .sheet(isPresented: $isNewAssetSheetShowing) {
                AssetCreationView(expense: $expense,
                                  isShowing: $isNewAssetSheetShowing)
            }
            .onChange(of: expense) { newExpense in
                if let newExpense {
                    financesStore.data.addExpense(newExpense)
                }
            }
        }
    }

    private func removeExpenses(at offsets: IndexSet, for headerDate: Date) {
        print(offsets.startIndex.description)

        guard let expenseGroup = expenseGroups[headerDate] else { return }
        let removedExpenses = offsets.map { expenseGroup[$0] }

        financesStore.data.removeExpenses(removedExpenses)
    }

    private var expenseGroups: [Date: [Expense]] {
        financesStore.data.expenses.sliced(by: [.year, .month, .day], for: \.date)
    }

    private var expenseGroupHeaders: [Date] {
        expenseGroups
            .map(\.key)
            .sorted { $0 > $1 }
    }
}

struct ExpensesTab_Previews: PreviewProvider {
    static var previews: some View {
        AssetsTab()
    }
}
