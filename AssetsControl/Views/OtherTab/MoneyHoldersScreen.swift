//
//  MoneyHoldersScreen.swift
//  AssetsControl
//
//  Created by Igoryok on 14.10.2023.
//

import SwiftUI

struct MoneyHoldersScreen: View {
    @EnvironmentObject private var financesStore: FinancialDataStore

    @State private var isMoneyHolderCreationSheetShowing: Bool = false
    @State private var newMoneyHolder: MoneyHolder?
    @State private var isEditSheetShowing: Bool = false
    @State private var selectedMoneyHolderId: UUID?
    @State private var isAdjustAmountAlertShowing: Bool = false
    @State private var adjustAmountText: String = ""

    var body: some View {
        ScrollView {
            LazyHStack {
                pageView
            }
        }
        .navigationTitle(currentMoneyHolder?.name ?? "Money Holders")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    if currentMoneyHolder != nil {
                        Button {
                            adjustAmountText = String(currentAmount.count)
                            isAdjustAmountAlertShowing = true
                        } label: {
                            Image(systemName: "plus.forwardslash.minus")
                        }
                        
                        Button {
                            isEditSheetShowing = true
                        } label: {
                            Image(systemName: "pencil")
                        }
                    }
                    
                    Button {
                        isMoneyHolderCreationSheetShowing = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
        }
        .sheet(isPresented: $isEditSheetShowing) {
            guard let currentMoneyHolder else {
                return
            }
        } content: {
            MoneyHolderCreationView(moneyHolder: Binding(
                get: { financesStore.data.moneyHolders.first(where: { $0.id == currentMoneyHolder!.id }) },
                set: { newEditedMoneyHolder in
                    guard let newEditedMoneyHolder else { return }
                    financesStore.data.updateMoneyHolder(withId: currentMoneyHolder!.id, to: newEditedMoneyHolder)
                }
            ))
        }
        .sheet(isPresented: $isMoneyHolderCreationSheetShowing) {
            guard let newMoneyHolder else {
                return
            }

            financesStore.data.addMoneyHolder(newMoneyHolder)
            self.newMoneyHolder = nil
        } content: {
            MoneyHolderCreationView(moneyHolder: $newMoneyHolder)
        }
        .alert("Adjust amount", isPresented: $isAdjustAmountAlertShowing) {
            TextField("Actual amount", text: $adjustAmountText)
                .keyboardType(.decimalPad)
            
            Button("Adjust") {
                adjustInitialMoney()
            }
            
            Button("Cancel", role: .cancel) {
                adjustAmountText = ""
            }
        } message: {
            Text("Enter the actual current amount to adjust the initial balance")
        }
    }

    private var pageView: some View {
        TabView(selection: $selectedMoneyHolderId) {
            ForEach(moneyHolders) { moneyHolder in
                MoneyHolderScreen(data: moneyHolder)
                    .tag(moneyHolder.id)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .tabViewStyle(PageTabViewStyle())
        .onAppear {
            if selectedMoneyHolderId == nil && !moneyHolders.isEmpty {
                selectedMoneyHolderId = moneyHolders.first?.id
            }
        }
        .onChange(of: moneyHolders) { _ in
            if let selectedId = selectedMoneyHolderId,
               !moneyHolders.contains(where: { $0.id == selectedId }) {
                selectedMoneyHolderId = moneyHolders.first?.id
            }
        }
    }

    private var moneyHolders: [MoneyHolder] {
        financesStore.data.moneyHolders
    }
    
    private var currentMoneyHolder: MoneyHolder? {
        guard let selectedMoneyHolderId = selectedMoneyHolderId else { return nil }
        return financesStore.data.moneyHolders.first(where: { $0.id == selectedMoneyHolderId })
    }
    
    private var currentAmount: Money {
        guard let currentMoneyHolder = currentMoneyHolder else { return Money(0, of: .dollar) }
        return financesStore.data.getCurrentAmount(for: currentMoneyHolder)
    }
    
    private func adjustInitialMoney() {
        guard let currentMoneyHolder = currentMoneyHolder,
              let actualAmount = Double(adjustAmountText.replacingOccurrences(of: ",", with: ".")) else {
            return
        }
        
        let actualMoney = Money(actualAmount, of: currentMoneyHolder.initialMoney.currency)
        financesStore.data.adjustInitialMoney(for: currentMoneyHolder, to: actualMoney)
        
        adjustAmountText = ""
    }
}

struct MoneyHoldersScreen_Previews: PreviewProvider {
    static var previews: some View {
        MoneyHoldersScreen()
            .environmentObject(FinancialDataStore())
    }
}
