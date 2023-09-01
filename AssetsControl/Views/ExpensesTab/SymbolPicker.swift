//
//  SymbolPicker.swift
//  My Assets
//
//  Created by Jayden Irwin on 2021-10-26.
//  Copyright © 2021 Jayden Irwin. All rights reserved.
//

import SwiftUI

struct SymbolPicker: View {
    @Binding var selected: Symbol

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 42, maximum: 42))]) {
            ForEach(Symbol.allCases) { symbol in
                ZStack {
                    if symbol == selected {
                        getSelectedBackground(symbol: symbol)
                    } else {
                        Circle()
                            .fill(Color(UIColor.tertiarySystemGroupedBackground))
                    }

                    Image(safeSystemImage: "\(symbol.rawValue).fill", default: symbol.rawValue)
                        .foregroundColor(symbol == selected ? Color.white : symbol.color)
                }
                .frame(height: 42)
                .onTapGesture {
                    selected = symbol
                }
            }
        }
        .imageScale(.large)
        .font(.system(size: 17, weight: .medium))
        .padding(.horizontal, -4)
        .padding(.vertical, 12)
    }

    @ViewBuilder
    func getSelectedBackground(symbol: Symbol) -> some View {
        if #available(iOS 16.0, *) {
            Circle()
                .fill(symbol.color.gradient)
        } else {
            Circle()
                .fill(symbol.color)
        }
    }
}

struct SymbolPicker_Previews: PreviewProvider {
    static var previews: some View {
         SymbolPickerView()
     }
     
     private struct SymbolPickerView : View {
         @State var selectedSymbol = Symbol.defaultSymbol
         
         var body: some View {
             VStack {
                 Text(selectedSymbol.suggestedTitle)
                 
                 SymbolPicker(selected: $selectedSymbol)
             }
         }
     }
}
