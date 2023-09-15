//
//  MoneyHolderPicker.swift
//  AssetsControl
//
//  Created by Igoryok on 12.09.2023.
//

import SwiftUI

struct MoneyHolderPicker: View {
    @Binding var selected: MoneyHolder

    var moneyHolders: [MoneyHolder]

    var body: some View {
        Picker("Source", selection: $selected) {
            ForEach(moneyHolders, id: \.self) { moneyHolder in
                Label(moneyHolder.name, systemImage: moneyHolder.symbol.systemImageName)
                    .tag(moneyHolder.id)
            }
        }
    }
}

struct MoneyHolderPicker_Previews: PreviewProvider {
    static var previews: some View {
        MoneyHolderPickerView()
    }

    private struct MoneyHolderPickerView: View {
        let moneyHolders: [MoneyHolder] = [.test, MoneyHolder(name: "MoneyHolder")]

        @State private var selectedMoneyHolder = MoneyHolder.test

        var body: some View {
            VStack {
                HStack {
                    Text(selectedMoneyHolder.name)

                    Text(selectedMoneyHolder.description)
                }

                MoneyHolderPicker(selected: $selectedMoneyHolder,
                                  moneyHolders: moneyHolders)
            }
        }
    }
}
