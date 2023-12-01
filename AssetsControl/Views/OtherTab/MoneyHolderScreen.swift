//
//  MoneyHolderScreen.swift
//  AssetsControl
//
//  Created by Igoryok on 14.10.2023.
//

import SwiftUI

struct MoneyHolderScreen: View {
    let data: MoneyHolder

    @EnvironmentObject private var financesStore: FinancialDataStore

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.green)
                .frame(height: 200)
                .padding()
                .navigationTitle(data.name)

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
        }
    }

    // TODO: test it
    private func removeExpenses(at offsets: IndexSet, for headerDate: Date) {
        guard let expenseGroup = expenseGroups[headerDate] else { return }
        let removedExpenses = offsets.map { expenseGroup[$0] }

        financesStore.data.removeExpenses(removedExpenses)
    }

    private var expenses: [Expense] {
        financesStore.data.expenses.filter { $0.moneyHolderSource == data }
    }

    private var expenseGroups: [Date: [Expense]] {
        expenses.sliced(by: [.year, .month, .day], for: \.date)
    }

    private var expenseGroupHeaders: [Date] {
        expenseGroups
            .map(\.key)
            .sorted { $0 > $1 }
    }
}

struct MoneyHolderScreen_Previews: PreviewProvider {
    @StateObject private static var financesStore: FinancialDataStore = .init()

    static var previews: some View {
        MoneyHolderScreen(data: MoneyHolder.test)
            .environmentObject(financesStore)
    }
}
