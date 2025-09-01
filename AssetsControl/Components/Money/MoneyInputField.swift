//
//  MoneyInputField.swift
//
//  Created by Igoryok
//

import SwiftUI

struct MoneyInputField: View {
    @State private var moneyCurrency: Currency
    @State private var isPickerShowing = false
    @State private var isPositive = true

    @Binding private var money: Money

    init(initialMoney: Binding<Money>) {
        moneyCurrency = initialMoney.wrappedValue.currency

        _money = initialMoney
        _isPositive = State(wrappedValue: initialMoney.wrappedValue.count >= 0)
        print("_money = \(money)")
        print("initialMoney.wrappedValue.count = \(initialMoney.wrappedValue.count)")
        print("isPositive = \(isPositive)")
    }

    var body: some View {
        VStack {
            HStack {
                Button(isPositive ? "+" : "-") {
                    isPositive.toggle()

                    money.count *= -1
                }.buttonStyle(BorderedButtonStyle())

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
