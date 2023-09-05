//
//  SymbolImage.swift
//  My Assets
//
//  Created by Jayden Irwin on 2021-11-23.
//  Copyright © 2021 Jayden Irwin. All rights reserved.
//

import SwiftUI

struct SymbolImage: View {
    let symbol: Symbol
    
    var body: some View {
        Image(safeSystemImage: "\(symbol.rawValue).fill", default: symbol.rawValue)
            .foregroundColor(symbol.color)
    }
}

struct SymbolImage_Previews: PreviewProvider {
    static var previews: some View {
        SymbolImage(symbol: .defaultSymbol)
    }
}
