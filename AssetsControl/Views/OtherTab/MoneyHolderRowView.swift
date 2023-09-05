//
//  MoneyHolderRowView.swift
//  AssetsControl
//
//  Created by Igoryok on 07.04.2023.
//

import SwiftUI

struct MoneyHolderRowView: View {
    var data: MoneyHolder

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
    
    var moneyTextView: some View {
        Text(data.money.description)
            .font(.title3)
            .bold()
    }
}

struct MoneyHolderRowView_Previews: PreviewProvider {
    static var previews: some View {
        MoneyHolderRowView(data: MoneyHolder.test)
    }
}
