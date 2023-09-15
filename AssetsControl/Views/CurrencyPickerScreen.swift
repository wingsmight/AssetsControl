//
//  CurrencyPickerScreen.swift
//  AssetsControl
//
//  Created by Igoryok on 01.10.2023.
//

import SwiftUI

struct CurrencyPickerScreen: View {
    private static let bankrollSize = CGSize(width: 200, height: 100)
    private static let headerElementSpacing = 5.0
    private static let sideTextWidth = (UIScreen.screenWidth - bankrollSize.width - headerElementSpacing) / 2.0

    @Binding var selectedCurrency: Currency

    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .fill(LinearGradient(colors: [.black, .green.opacity(0.75), .green.opacity(0.0)], startPoint: .top, endPoint: .bottom))
                .ignoresSafeArea()
                .frame(height: Self.bankrollSize.height + 200)

            VStack {
                header

                picker
            }
            .frame(width: UIScreen.screenWidth)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    dismiss()
                } label: {
                    Text("Done")
                }
            }
        }
    }

    private var header: some View {
        HStack(alignment: .bottom, spacing: Self.headerElementSpacing) {
            HStack {
                Spacer()

                Text(selectedCurrency.code)
                    .foregroundColor(Color(.systemBackground))
                    .multilineTextAlignment(.trailing)
            }
            .frame(width: Self.sideTextWidth)

            BankrollView(currency: selectedCurrency)
                .frame(Self.bankrollSize)

            HStack {
                Text(selectedCurrency.description)
                    .foregroundColor(Color(.systemBackground))
                    .multilineTextAlignment(.leading)

                Spacer()
            }
            .frame(width: Self.sideTextWidth)
        }
        .padding(.bottom)
        .padding(.horizontal)
    }

    private var picker: some View {
        CurrencyPicker(selected: $selectedCurrency)
            .padding()
            .padding(.bottom)
            .ignoresSafeArea()
    }

    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct CurrencyPickerScreen_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
    }

    private struct Preview: View {
        @State private var selectedCurrency: Currency = .uruguayPesoEnUnidadesIndexadas

        var body: some View {
            CurrencyPickerScreen(selectedCurrency: $selectedCurrency)
        }
    }
}
