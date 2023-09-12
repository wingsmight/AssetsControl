//
//  GeneralError.swift
//
//  Created by Igoryok
//

import Foundation

enum GeneralError: Error {
    case runtime(String)
}

extension GeneralError: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .runtime(description):
            return description
        }
    }
}

extension GeneralError: LocalizedError {
    public var errorDescription: String? {
        description
    }
}
