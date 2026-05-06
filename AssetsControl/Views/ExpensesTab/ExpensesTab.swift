//
//  ExpensesTab.swift
//  AssetsControl
//
//  Created by Igoryok on 28.03.2023.
//

import SwiftUI

struct ExpensesTab: View {
    @EnvironmentObject private var financesStore: FinancialDataStore
    @EnvironmentObject private var userStore: UserDataStore

    @State private var isNewAssetSheetShowing: Bool = false
    @State private var isReceiptScannerShowing: Bool = false
    @State private var expense: Expense? = nil
    @State private var scannedExpenses: [Expense] = []

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
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isReceiptScannerShowing = true
                    } label: {
                        Label("Scan Receipt", systemImage: "doc.text.viewfinder")
                    }
                }
                
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
                ExpenseCreationView(expense: $expense,
                                  isShowing: $isNewAssetSheetShowing)
            }
            .sheet(isPresented: $isReceiptScannerShowing) {
                ReceiptScannerView(isPresented: $isReceiptScannerShowing,
                                 createdExpenses: $scannedExpenses)
            }
            .onChange(of: expense) { newExpense in
                if let newExpense {
                    financesStore.data.addExpense(newExpense)
                    
                    userStore.data.setLastMoneyHolderSource(newExpense.moneyHolderSource)
                }
            }
            .onChange(of: scannedExpenses) { newExpenses in
                for newExpense in newExpenses {
                    financesStore.data.addExpense(newExpense)
                    userStore.data.setLastMoneyHolderSource(newExpense.moneyHolderSource)
                }
                if !newExpenses.isEmpty {
                    scannedExpenses = []
                }
            }
        }
    }

    private func removeExpenses(at offsets: IndexSet, for headerDate: Date) {
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
    @StateObject private static var financialDataStore = FinancialDataStore()
    
    static var previews: some View {
        ExpensesTab()
            .environmentObject(financialDataStore)
    }
}
