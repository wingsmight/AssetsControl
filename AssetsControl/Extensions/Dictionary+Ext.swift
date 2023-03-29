//
//  Dictionary+Ext.swift
//
//  Created by Igoryok
//

import Foundation

extension [String: String] {
    func startsWith(_ prefix: String) -> [Value] {
        filter { $0.key.hasPrefix(prefix) }.map(\.value)
    }
}
