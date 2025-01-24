//
//  BTCPrice.swift
//  BTCLoader
//
//  Created by Damian Modernell on 23/1/25.
//

enum Currency {
    case USD

    var name: String {
        switch self {
        case .USD: "USD"
        }
    }
}

struct BTCPrice: Equatable {
    let amount: Double
    let currency: Currency
}
