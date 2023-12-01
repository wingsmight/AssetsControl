//
//  MoneyHolderCreationView.swift
//  AssetsControl
//
//  Created by Igoryok on 07.04.2023.
//

import SwiftUI

struct MoneyHolderCreationView: View {
    @Binding var moneyHolder: MoneyHolder?

    @State private var id: UUID? = nil
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var money: Money = .init(0)
    @State private var selectedSymbol: Symbol = .defaultSymbol
    @State private var moneyHolderSource: MoneyHolder = .init(name: "default")
    @State private var date: Date = .init()

    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name", text: $name)
                        .autocapitalization(.words)

                    TextField("Description", text: $description)
                        .autocapitalization(.words)

                    MoneyInputField(initialMoney: $money)
                        .buttonStyle(BorderlessButtonStyle())
                }

                Section {
                    DatePicker("Date", selection: $date)
                }

                Section {
                    SymbolPicker(selected: $selectedSymbol)
                }
            }
            .navigationTitle("New Money Holder")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        moneyHolder = nil
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        guard !name.isEmpty else {
                            moneyHolder = nil
                            dismiss()

                            return
                        }

                        moneyHolder = MoneyHolder(id: id,
                                                  name: name,
                                                  description: description,
                                                  symbol: selectedSymbol,
                                                  initialMoney: money,
                                                  initialDate: date)

                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            if let moneyHolder {
                id = moneyHolder.id
                name = moneyHolder.name
                description = moneyHolder.description
                money = moneyHolder.initialMoney
                selectedSymbol = moneyHolder.symbol
                date = moneyHolder.initialDate
            }
        }
    }

    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct MoneyHolderCreationView_Previews: PreviewProvider {
    static var previews: some View {
        MoneyHolderCreationView(moneyHolder: .constant(MoneyHolder(name: "")))
    }
}
