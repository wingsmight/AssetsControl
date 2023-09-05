//
//  ExpenseView.swift
//  AssetsControl
//
//  Created by Igoryok on 28.03.2023.
//

import SwiftUI

struct ExpenseView: View {
    var expense: Expense

    var body: some View {
        HStack {
            SymbolImage(symbol: expense.symbol)
                .font(.system(size: 17, weight: .medium))
                .frame(width: 32)

            Text(expense.name)

            Spacer()

            Text(NumberFormatterContainer.currencyFormatter.string(from: NSNumber(value: expense.monthlyCost))!)
        }
    }
}

struct ExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseView(expense: Expense.test)
    }
}
