//
//  MultiSelectPickerView.swift
//  Splus
//
//  Created by Igoryok on 29.01.2023.
//

import SwiftUI

struct MultiSelectPickerView<T: Identifiable & Hashable & CustomStringConvertible>: View {
    @State var sourceItems: [T]

    @Binding var selectedItems: [T]

    var body: some View {
        Form {
            List {
                ForEach(sourceItems, id: \.self) { item in
                    Button(action: {
                        withAnimation {
                            if self.selectedItems.contains(item) {
                                self.selectedItems.removeAll(where: { $0 == item })
                            } else {
                                self.selectedItems.append(item)
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "checkmark")
                                .opacity(self.selectedItems.contains(item) ? 1.0 : 0.0)
                            Text(item.description)
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
        }
        .listStyle(GroupedListStyle())
    }
}

struct MultiSelectItemList<T: Identifiable & Hashable>: View {
    var items: [T]
    let itemView: (T) -> AnyView

    @Binding var selected: [T]

    var body: some View {
        ForEach(items) { item in
            MultiSelectItemRow(
                item: item,
                itemView: itemView,
                isSelected: Binding<Bool>(get: {
                    selected.contains(item)
                }, set: { isSelected in
                    if isSelected {
                        selected.append(item)
                    } else {
                        selected.removeAll(where: { $0 == item })
                    }
                })
            )
        }
    }
}

struct MultiSelectItemRow<T>: View {
    let item: T
    let itemView: (T) -> AnyView

    @Binding var isSelected: Bool

    var body: some View {
        HStack {
            Toggle(isSelected: $isSelected)
                .frame(width: 25, height: 25)
                .padding(3)

            itemView(item)

            Spacer()
        }
        .onTapGesture {
            isSelected.toggle()
        }
    }

    struct Toggle: View {
        private let strokeRatio: CGFloat = 10.0
        private let fillRatio: CGFloat = 1.75
        private let animationSpeed: CGFloat = 2.5

        @Binding var isSelected: Bool

        var body: some View {
            GeometryReader { metrics in
                ZStack {
                    Circle()
                        .stroke(Color.blue, lineWidth: metrics.size.width / strokeRatio)

                    Circle()
                        .fill(Color.blue.opacity(isSelected ? 1.0 : 0.0))
                        .frame(width: metrics.size.width / fillRatio, height: metrics.size.height / fillRatio)
                        .animation(.easeIn.speed(animationSpeed), value: isSelected)
                }
            }
        }
    }
}

struct MultiSelectPickerView_Previews: PreviewProvider {
    private static let products = [
        Product.test,
        Product.test,
    ]

    static var previews: some View {
        VStack {
            MultiSelectItemList<Product>(items: products,
                                         itemView: { product in
                                             AnyView(Text(product.name))
                                         },
                                         selected: .constant([]))
        }
    }
}
