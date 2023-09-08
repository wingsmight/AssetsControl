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
                        .onDelete(perform: removeExpense)
                    }
                }
            }
            .padding()
            .navigationTitle("Expenses")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isNewAssetSheetShowing = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
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

    func removeExpense(at offsets: IndexSet) {
        financesStore.data.expenses.remove(atOffsets: offsets)
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
