//
//  BTCPrice.swift
//  BTCLoader
//
//  Created by Damian Modernell on 23/1/25.
//

public enum Currency {
    case USD

    var name: String {
        switch self {
        case .USD: "USD"
        }
    }
}

public struct BTCPrice: Equatable {
    public let amount: Double
    public let currency: Currency

    public init(amount: Double, currency: Currency) {
        self.amount = amount
        self.currency = currency
    }
}
