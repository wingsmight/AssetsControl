//
//  BankrollView.swift
//
//  Created by Igoryok
//

import SwiftUI

struct BankrollView: View {
    let currency: Currency
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color("BankrollBackground"))

            BankrollShape()
                .fill(Color("BankrollForeground"))
                .padding(6)
            
            Circle()
                .fill(Color("BankrollBackground"))
                .padding(14)
                .overlay (
                    Text(currency.symbol)
                        .font(.largeTitle)
                        .bold()
                        .autoSize()
                        .foregroundColor(Color("BankrollForeground"))
                        .padding()
                )
            
        }
    }
}

struct BankrollView_Previews: PreviewProvider {
    static var previews: some View {
        BankrollView(currency: .uruguayPesoEnUnidadesIndexadas)
            .frame(CGSize(width: 200, height: 100))
    }
}
