//
//  AssetCreationView.swift
//  AssetsControl
//
//  Created by Igoryok on 28.03.2023.
//

import SwiftUI

struct AssetCreationView: View {
    @Binding var parentExpense: Expense?
    @Binding var isShowing: Bool

    @StateObject var expense = Expense(name: "", symbol: Symbol.defaultSymbol, monthlyCost: 0)
    @State var cost: Double?

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name", text: $expense.name)
                        .autocapitalization(.words)

                    OptionalDoubleField("Monthly Cost ($)",
                                        value: $cost,
                                        formatter: NumberFormatterContainer.currencyFormatter)
                }
                Section {
                    SymbolPicker(selected: $expense.symbol)
                }
            }
            .navigationTitle("Add Expense")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        if let cost {
                            self.expense.baseMonthlyCost = cost
                            
                            parentExpense = self.expense

                            dismiss()
                        }
                    }
                }
            }
        }
    }

    func dismiss() {
        isShowing = false
    }
}

struct AssetCreationView_Previews: PreviewProvider {
    static var previews: some View {
        AssetCreationView(parentExpense: .constant(nil),
                          isShowing: .constant(false))
    }
}
