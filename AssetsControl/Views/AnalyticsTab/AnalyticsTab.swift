//
//  AnalyticsTab.swift
//  AssetsControl
//
//  Created by Igoryok
//

import SwiftUI
import SwiftUICharts

struct AnalyticsTab: View {
    @EnvironmentObject private var financesStore: FinancialDataStore
    
    @StateObject private var model = ViewModel()

    var body: some View {
        NavigationView {
            VStack {
                headerView
                chartView
            }
            .padding()
            .gesture(DragGesture()
                .onEnded { value in
                    if value.translation.width > 0 {
                        model.handleSwipeGesture(direction: .right)
                    } else if value.translation.width < 0 {
                        model.handleSwipeGesture(direction: .left)
                    }
                }
            )
        }
    }

    // Header view showing month and year
    private var headerView: some View {
        VStack {
            Text(model.formattedMonthYearText())
                .font(.largeTitle)
                .bold()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // Chart view displaying the expenses for the selected month
    private var chartView: some View {
        let currencySum = model.totalSumForCurrentMonth(financialData: financesStore.data)
        
        return HStack {
            ForEach(currencySum.sorted(by: { $0.value > $1.value }), id: \.key) { currency, sum in
                VStack {
                    Text(currency.symbol)
                        .font(.title)
                        .bold()
                    
                    Text(Money(sum, of: currency).description)
                        .font(.title)
                        .bold()
                }
            }
        }
        
//        let expensesForMonth = model.expensesForCurrentMonth(financialData: financesStore.data)

//        return Chart {
//            ForEach(expensesForMonth) { expense in
//                BarMark(
//                    x: .value("Expense", expense.name),
//                    y: .value("Amount", expense.amount.value)
//                )
//                .foregroundStyle(expense.color)
//            }
//        }
//        .frame(height: 300)
        
//        return PieChartView(data: expensesForMonth, title: "Expenses")
    }
}

#Preview {
    AnalyticsTab()
}
