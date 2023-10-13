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
        ZStack {
            HStack {
                SymbolImage(symbol: data.source.symbol)

                Spacer()
                Image(systemName: "arrow.right")
                    .foregroundColor(.secondary)
                Spacer()

                moneyTextView

                Spacer()
                Image(systemName: "arrow.right")
                    .foregroundColor(.secondary)
                Spacer()

                SymbolImage(symbol: data.target.symbol)
            }
        }
    }

    var moneyTextView: some View {
        Text(data.amount.description)
            .font(.title3)
            .bold()
    }
}

struct TransferRowView_Previews: PreviewProvider {
    static var previews: some View {
        TransferRowView(data: Transfer.test)
    }
}
