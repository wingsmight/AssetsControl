//
//  IncomeType.swift
//  AssetsControl
//
//  Created by Igoryok on 09.09.2023.
//

enum IncomeType: Codable {
    case active(ActiveIncome)
    case passive(PassiveIncome)
    case portfolio(PortfolioIncome)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let activeIncome = try? container.decode(ActiveIncome.self) {
            self = .active(activeIncome)
        } else if let passiveIncome = try? container.decode(PassiveIncome.self) {
            self = .passive(passiveIncome)
        } else if let portfolioIncome = try? container.decode(PortfolioIncome.self) {
            self = .portfolio(portfolioIncome)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid income type")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .active(activeIncome):
            try container.encode(activeIncome)
        case let .passive(passiveIncome):
            try container.encode(passiveIncome)
        case let .portfolio(portfolioIncome):
            try container.encode(portfolioIncome)
        }
    }

    var income: any Income {
        switch self {
        case let .active(activeIncome):
            return activeIncome
        case let .passive(passiveIncome):
            return passiveIncome
        case let .portfolio(portfolioIncome):
            return portfolioIncome
        }
    }
}

extension Income {
    var incomeType: IncomeType {
        get throws {
            if let activeIncome = self as? ActiveIncome {
                return IncomeType.active(activeIncome)
            } else if let passiveIncome = self as? PassiveIncome {
                return IncomeType.passive(passiveIncome)
            } else if let portfolioIncome = self as? PortfolioIncome {
                return IncomeType.portfolio(portfolioIncome)
            } else {
                throw GeneralError.runtime("Cannot convert Income to IncomeType")
            }
        }
    }
}
