//
//  MoneyHolderScreen.swift
//  AssetsControl
//
//  Created by Igoryok on 14.10.2023.
//

import FluidGradient
import SwiftUI

struct MoneyHolderScreen: View {
    let data: MoneyHolder

    @EnvironmentObject private var financesStore: FinancialDataStore
    
    @State private var isEditSheetShowing: Bool = false

    var body: some View {
        VStack {
            ZStack {
                FluidGradient(blobs: [.red, .green, .blue],
                              highlights: [.yellow, .orange, .purple],
                              speed: 1.0,
                              blur: 0.75)
                    .cornerRadius(10)

                Text(data.initialMoney.currency.symbol)
                    .foregroundStyle(Color.white.opacity(0.15))
                    .font(.system(size: 500))
                    .minimumScaleFactor(0.01)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .padding()

                Text(currentAmount.description)
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .padding()
            }
            .frame(height: 200)
            .padding()
            .navigationTitle(data.name)

            Text(data.description)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()

            Button {
                // TODO: add confirm sheet
//                financesStore.data.removeMoneyHolder(data)
            } label: {
                Image(systemName: "trash")
                    .foregroundStyle(.red)
            }

            Text(data.initialMoney.count.description)

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
        .toolbar {
            Button {
                isEditSheetShowing = true
            } label: {
                Image(systemName: "pencil")
            }
        }
        .sheet(isPresented: $isEditSheetShowing) {
            MoneyHolderCreationView(moneyHolder: Binding(
                get: { financesStore.data.moneyHolders.first(where: { $0.id == data.id }) },
                set: { newEditedMoneyHolder in
                    guard let newEditedMoneyHolder else { return }

                    financesStore.data.updateMoneyHolder(withId: data.id, to: newEditedMoneyHolder)
                }
            ))
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

    private var incomes: [ActiveIncome] {
        financesStore.data.activeIncomes.filter { $0.target == data }
    }

    private var incomeTransfers: [Transfer] {
        financesStore.data.transfers.filter { $0.target == data }
    }

    private var outcomeTransfers: [Transfer] {
        financesStore.data.transfers.filter { $0.source == data }
    }

    private var currentAmount: Money {
        financesStore.data.getCurrentAmount(for: data)
    }
}

struct MoneyHolderScreen_Previews: PreviewProvider {
    @StateObject private static var financesStore: FinancialDataStore = .init()

    static var previews: some View {
        MoneyHolderScreen(data: MoneyHolder.test)
            .environmentObject(financesStore)
    }
}
