//
//  AssetRowView.swift
//  AssetsControl
//
//  Created by Igoryok
//  

import SwiftUI

struct AssetRowView: View {
    var asset: Asset

    var body: some View {
        HStack {
            SymbolImage(symbol: asset.symbol)
                .font(.system(size: 17, weight: .medium))
                .frame(width: 32)

            Text(asset.name)

            Spacer()

            Text(asset.amount.description)
        }
    }
}

#Preview {
    AssetRowView(asset: Asset.test)
}
