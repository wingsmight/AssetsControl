//
//  IncomesTab.swift
//  AssetsControl
//
//  Created by Igoryok on 08.09.2023.
//

import SwiftUI

struct IncomesTab: View {
    @EnvironmentObject private var financesStore: FinancialDataStore

    @State private var isNewIncomeSheetShowing: Bool = false
    @State private var newIncome: (any Income)? = nil

    var body: some View {
        NavigationView {
            List {
                ForEach(incomeGroupHeaders, id: \.self) { headerDate in
                    Section(header: Text(headerDate, style: .date)) {
                        ForEach(incomeGroups[headerDate]!, id: \.id) { income in
                            if let activeIncome = income as? ActiveIncome {
                                ActiveIncomeView(income: activeIncome)
                            }
                        }
                        .onDelete { offsetIndexSet in
                            removeIncomes(at: offsetIndexSet, for: headerDate)
                        }
                    }
                }
            }
            .navigationTitle("Incomes")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isNewIncomeSheetShowing = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $isNewIncomeSheetShowing) {
                IncomeCreationView(income: $newIncome,
                                   isShowing: $isNewIncomeSheetShowing)
            }
            .onChange(of: isNewIncomeSheetShowing) { isNewIncomeSheetShowing in
                if !isNewIncomeSheetShowing,
                   let newIncome
                {
                    financesStore.data.addIncome(newIncome)
                }
            }
        }
    }

    private func removeIncomes(at offsets: IndexSet, for headerDate: Date) {
        print(offsets.startIndex.description)

        guard let incomeGroup = incomeGroups[headerDate] else { return }
        let removedIncomes = offsets.map { incomeGroup[$0] }

        financesStore.data.removeIncomes(removedIncomes)
    }

    private var incomeGroups: [Date: [any Income]] {
        financesStore.data.incomes.sliced(by: [.year, .month, .day], for: \.initialDate)
    }

    private var incomeGroupHeaders: [Date] {
        incomeGroups
            .map(\.key)
            .sorted { $0 > $1 }
    }
}

struct IncomesTab_Previews: PreviewProvider {
    static var previews: some View {
        IncomesTab()
    }
}
