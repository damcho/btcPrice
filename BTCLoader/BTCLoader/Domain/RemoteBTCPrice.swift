//
//  RemoteBTCPrice.swift
//  BTCLoader
//
//  Created by Damian Modernell on 23/1/25.
//

public enum RemoteBTCCurrency {
    case USD

    public var code: String {
        switch self {
        case .USD: "USD"
        }
    }
}

public struct RemoteBTCPrice: Equatable {
    public let amount: Double
    public let currency: RemoteBTCCurrency

    public init(amount: Double, currency: RemoteBTCCurrency) {
        self.amount = amount
        self.currency = currency
    }
}
