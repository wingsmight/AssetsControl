//
//  MoneyInputField.swift
//
//  Created by Igoryok
//

import SwiftUI

struct MoneyInputField: View {
    @State private var moneyCurrency: Currency
    @State private var isPickerShowing = false

    @Binding private var money: Money

    init(initialMoney: Binding<Money>) {
        moneyCurrency = initialMoney.wrappedValue.currency

        _money = initialMoney
    }

    var body: some View {
        VStack {
            HStack {
                MoneyCountField("Current Money Count",
                                value: Binding<Double?>($money.count))

                Button {
                    isPickerShowing.toggle()
                } label: {
                    CurrencyIcon(currency: money.currency)
                }
            }
            .background(
                NavigationLink(isActive: $isPickerShowing, destination: {
                    VStack {
                        CurrencyPickerScreen(selectedCurrency: Binding<Currency>(
                            get: { money.currency },
                            set: { money = Money(money.count, of: $0) }
                        ))
                    }
                }, label: {
                    EmptyView()
                })
            )
        }
    }
}

struct MoneyInputField_Previews: PreviewProvider {
    static var previews: some View {
        MoneyInputField(initialMoney: .constant(Money(0)))
    }
}
