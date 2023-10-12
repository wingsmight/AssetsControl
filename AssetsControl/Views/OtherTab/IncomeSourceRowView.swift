//
//  IncomeSourceRowView.swift
//  AssetsControl
//
//  Created by Igoryok on 11.10.2023.
//

import SwiftUI

struct IncomeSourceRowView: View {
    var data: IncomeSource

    var body: some View {
        HStack {
            SymbolImage(symbol: data.symbol)
                .font(.system(size: 35, weight: .medium))

            VStack(alignment: .leading) {
                Text(data.name)
                    .font(.title)

                Text(data.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            moneyTextView
        }
    }

    @ViewBuilder
    var moneyTextView: some View {
        if let defaultAmount = data.defaultAmount {
            Text("\(defaultAmount) \(data.currency.symbol)")
                .font(.title3)
                .bold()
        } else {
            EmptyView()
        }
    }
}

struct IncomeSourceRowView_Previews: PreviewProvider {
    static var previews: some View {
        IncomeSourceRowView(data: IncomeSource.test)
    }
}
