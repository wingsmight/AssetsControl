//
//  Collection+Ext.swift
//  Splus
//
//  Created by Igoryok on 26.02.2023.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    subscript(safe index: Index) -> Iterator.Element? {
        (startIndex <= index && index < endIndex) ? self[index] : nil
    }
}

extension MutableCollection where Self: RandomAccessCollection {
    mutating func sort(
        by firstPredicate: (Element, Element) -> Bool,
        _ secondPredicate: (Element, Element) -> Bool,
        _ otherPredicates: ((Element, Element) -> Bool)...
    ) {
        sort(by:) { lhs, rhs in
            if firstPredicate(lhs, rhs) { return true }
            if firstPredicate(rhs, lhs) { return false }
            if secondPredicate(lhs, rhs) { return true }
            if secondPredicate(rhs, lhs) { return false }
            for predicate in otherPredicates {
                if predicate(lhs, rhs) { return true }
                if predicate(rhs, lhs) { return false }
            }
            return false
        }
    }
}

extension Sequence {
    func sorted(
        by firstPredicate: (Element, Element) -> Bool,
        _ secondPredicate: (Element, Element) -> Bool,
        _ otherPredicates: ((Element, Element) -> Bool)...
    ) -> [Element] {
        sorted(by:) { lhs, rhs in
            if firstPredicate(lhs, rhs) { return true }
            if firstPredicate(rhs, lhs) { return false }
            if secondPredicate(lhs, rhs) { return true }
            if secondPredicate(rhs, lhs) { return false }
            for predicate in otherPredicates {
                if predicate(lhs, rhs) { return true }
                if predicate(rhs, lhs) { return false }
            }
            return false
        }
    }
}
