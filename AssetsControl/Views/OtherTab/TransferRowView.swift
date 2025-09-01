//
//  TransferRowView.swift
//  AssetsControl
//
//  Created by Igoryok on 13.10.2023.
//

import SwiftUI

struct TransferRowView: View {
    var data: Transfer

    var body: some View {
        VStack(alignment: .center) {
            HStack {
                SymbolImage(symbol: data.source.symbol)

                Text(data.source.name)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            moneyTextView

            HStack {
                Text(data.target.name)

                SymbolImage(symbol: data.target.symbol)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

    var moneyTextView: some View {
        HStack {
            MoneyView(amount: data.moneyAmount)
            
            if data.amount != data.receivedAmount {
                Image(systemName: "arrow.right")
                    .foregroundColor(.secondary)

                MoneyView(amount: data.receivedMoneyAmount)
            }
        }
    }

    struct MoneyView: View {
        let amount: Money

        var body: some View {
            Text(amount.description)
                .font(.title3)
                .bold()
        }
    }
}

struct TransferRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            TransferRowView(data: Transfer.test)

            TransferRowView(data: Transfer.test2)
        }
    }
}
