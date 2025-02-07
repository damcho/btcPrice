//
//  BTCPriceViewModel.swift
//  BTCPriceLoaderApp
//
//  Created by Damian Modernell on 26/1/25.
//
import BTCUtilityCore
import Foundation

enum BTCPriceLabelFormat {
    case btc

    func value(for price: BTCPriceViewRepresentation) -> String {
        "BTC/\(price.currency.code): \(price.stringPriceRepresentation)"
    }
}

final class BTCPriceViewModel: ObservableObject {
    @Published var btcPriceLabel: String = ""
    var btcPrice: BTCPriceViewRepresentation = .init(price: 0, color: .black) {
        didSet {
            btcPriceLabel = BTCPriceLabelFormat.btc.value(for: btcPrice)
        }
    }
}

// MARK: BTCPriceDisplayable

extension BTCPriceViewModel: BTCPriceDisplayable {
    func display(_ btcPrice: BTCPrice) {
        self.btcPrice = self.btcPrice.updateBTCPriceRepresentation(
            for: btcPrice.amount
        )
    }
}
