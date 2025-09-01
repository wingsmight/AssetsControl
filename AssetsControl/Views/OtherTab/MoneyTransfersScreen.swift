//
//  MoneyTransfersScreen.swift
//  AssetsControl
//
//  Created by Igoryok
//

import SwiftUI

struct MoneyTransfersScreen: View {
    @EnvironmentObject private var financesStore: FinancialDataStore

    @State private var newTransfer: Transfer?
    @State private var editedTransfer: Transfer?
    @State private var isTransferCreationSheetShowing: Bool = false
    @State private var transferRowId: UUID = .init()

    var body: some View {
        transferList
            .navigationTitle("Money Transfers")
            .toolbar {
                Button {
                    isTransferCreationSheetShowing = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
            }
            .sheet(isPresented: $isTransferCreationSheetShowing) {
                guard let newTransfer else {
                    return
                }

                financesStore.data.addTransfer(newTransfer)
                self.newTransfer = nil
            } content: {
                TransferCreationView(transfer: $newTransfer)
            }
            .sheet(item: $editedTransfer) { editedTransfer in
                TransferCreationView(transfer: Binding(
                    get: { financesStore.data.transfers.first(where: { $0.id == editedTransfer.id }) },
                    set: { newEditedTransfer in
                        guard let newEditedTransfer else { return }

                        financesStore.data.updateTransfer(withId: editedTransfer.id, to: newEditedTransfer)

                        transferRowId = UUID()
                    }
                ))
            }
    }

    private var transferList: some View {
        List {
            ForEach(transferGroupHeaders, id: \.self) { headerDate in
                Section(header: Text(headerDate, style: .date)) {
                    ForEach(transferGroups[headerDate]!) { transfer in
                        TransferRowView(data: transfer)
                    }
                    .onDelete { offsetIndexSet in
                        removeTransfers(at: offsetIndexSet, for: headerDate)
                    }
                }
            }
        }
    }
    
    private func removeTransfers(at offsets: IndexSet, for headerDate: Date) {
        guard let transferGroup = transferGroups[headerDate] else { return }
        let removedTransfers = offsets.map { transferGroup[$0] }

        financesStore.data.removeTransfers(removedTransfers)
    }

    private var transfers: [Transfer] {
        financesStore.data.transfers
    }
    
    private var transferGroups: [Date: [Transfer]] {
        financesStore.data.transfers.sliced(by: [.year, .month, .day], for: \.date)
    }

    private var transferGroupHeaders: [Date] {
        transferGroups
            .map(\.key)
            .sorted { $0 > $1 }
    }
}

struct MoneyTransfersScreen_Previews: PreviewProvider {
    static var previews: some View {
        MoneyTransfersScreen()
            .environmentObject({ () -> FinancialDataStore in
                let financesStore = FinancialDataStore()

                financesStore.data.addTransfer(.test)
                financesStore.data.addTransfer(.test2)

                return financesStore
            }())
    }
}
