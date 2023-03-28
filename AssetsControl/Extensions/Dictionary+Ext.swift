//
//  Dictionary+Ext.swift
//  Splus
//
//  Created by Igoryok on 26.02.2023.
//

import Foundation

extension [String: String] {
    func startsWith(_ prefix: String) -> [Value] {
        filter { $0.key.hasPrefix(prefix) }.map(\.value)
    }
}
