//
//  ActiveIncomeView.swift
//  AssetsControl
//
//  Created by Igoryok on 08.09.2023.
//

import SwiftUI

struct ActiveIncomeView: View {
    var income: ActiveIncome

    var body: some View {
        HStack {
            SymbolImage(symbol: income.symbol)
                .font(.system(size: 17, weight: .medium))
                .frame(width: 32)

            Text(income.name)

            Spacer()

            Text(income.amount.description)
        }
    }
}

struct ActiveIncomeView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveIncomeView(income: ActiveIncome.test)
    }
}
