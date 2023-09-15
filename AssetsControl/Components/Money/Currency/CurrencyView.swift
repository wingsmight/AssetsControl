//
//  CurrencyView.swift
//
//  Created by Igoryok
//

import SwiftUI

struct CurrencyView: View {
    let currency: Currency

    var body: some View {
        HStack {
            CurrencyIcon(currency: currency)
                .padding(6.5)

            Text(currency.description)

            Spacer()

            Text(currency.rawValue)
        }
    }
}

struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyView(currency: .dollar)
    }
}
