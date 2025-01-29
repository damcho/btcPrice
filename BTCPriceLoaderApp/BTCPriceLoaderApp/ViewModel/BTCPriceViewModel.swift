//
//  BTCPriceViewModel.swift
//  BTCPriceLoaderApp
//
//  Created by Damian Modernell on 26/1/25.
//
import BTCUtilityCore
import Foundation

final class BTCPriceViewModel: ObservableObject {
    @Published var btcPriceLabel: String = ""
    var btcPrice: BTCPriceViewRepresentation = .init(price: 0, color: .black) {
        didSet {
            btcPriceLabel = "BTC/\(btcPrice.currency.code): \(btcPrice.stringPriceRepresentation)"
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
