//
//  Comparable+Ext.swift
//  Splus
//
//  Created by Igoryok on 19.02.2023.
//

import Foundation

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}
