//
//  ForEachWithIndex.swift
//
//  Created by Igoryok
//

import SwiftUI

func ForEachWithIndex<Data: RandomAccessCollection>(
    _ data: Data,
    @ViewBuilder content: @escaping (Data.Index, Data.Element) -> some View
) -> some View where Data.Element: Identifiable, Data.Element: Hashable {
    ForEach(Array(zip(data.indices, data)), id: \.1) { index, element in
        content(index, element)
    }
}
