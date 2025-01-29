//
//  BTCPriceViewRepresentation.swift
//  BTCPriceLoaderApp
//
//  Created by Damian Modernell on 28/1/25.
//

import BTCUtilityCore
import Foundation
import SwiftUI

struct BTCPriceViewRepresentation: Equatable {
    private let price: Double
    let currency: Currency
    let color: Color

    var stringPriceRepresentation: String {
        price.formatted(.currency(code: currency.code).presentation(.narrow))
    }

    init(price: Double, currency: Currency = .USD, color: Color) {
        self.price = price
        self.color = color
        self.currency = currency
    }

    func updateBTCPriceRepresentation(for newPrice: Double) -> BTCPriceViewRepresentation {
        .init(
            price: newPrice,
            currency: currency,
            color: colorFor(
                newBTCPrice: newPrice
            )
        )
    }

    private func colorFor(newBTCPrice: Double) -> Color {
        if newBTCPrice == price {
            .black
        } else if newBTCPrice > price {
            .green
        } else {
            .red
        }
    }
}
