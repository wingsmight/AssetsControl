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
            
            Text(expense.name)
            
            Spacer()
            
            Text(NumberFormatterContainer.currencyFormatter.string(from: NSNumber(value: expense.monthlyCost))!)
        }
    }
}

struct ExpenseView_Previews: PreviewProvider {
    static var previews: some View {
//        ExpenseView(expense: Expense.test) // TODO: why doesn't is work?
        ExpenseView(expense: Expense(name: "Expense",
                                     symbol: Symbol.defaultSymbol,
                                     monthlyCost: 100.0))
    }
}
