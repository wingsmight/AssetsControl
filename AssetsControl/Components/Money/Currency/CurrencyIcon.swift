//
//  CurrencyIcon.swift
//
//  Created by Igoryok
//

import SwiftUI

struct CurrencyIcon: View {
    private static let size: CGSize = .init(width: 35, height: 35)
    private static let backgroundColor: Color = .green

    let currency: Currency

    var body: some View {
        Text(currency.symbol)
            .autoSize()
            .padding(1.5)
            .foregroundColor(.white)
            .background(getBackground(currency: currency)
                .frame(Self.size))
            .frame(Self.size)
    }

    // TODO: make gradient for iOS 14, 15 too
    // TODO: same as in SymbolPicker
    @ViewBuilder
    func getBackground(currency: Currency) -> some View {
        if #available(iOS 16.0, *) {
            Circle()
                .fill(Self.backgroundColor.gradient)
        } else {
            Circle()
                .fill(Self.backgroundColor)
        }
    }
}

struct CurrencyIcon_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyIcon(currency: .dollar)
    }
}
