//
//  BTCPriceCLIDisplayable.swift
//  BTCPriceCLI
//
//  Created by Damian Modernell on 29/1/25.
//

import Foundation
import BTCUtilityCore
import BTCLoader

struct BTCPriceCLIDisplayable: BTCPriceDisplayable {
    func display(_ btcPrice: BTCPrice) {
        print("BTC/\(btcPrice.currency): \(btcPrice.amount.formatted(.currency(code: btcPrice.currency.code).presentation(.narrow)))")
    }
}
