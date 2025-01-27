//
//  BTCLoaderAdapter.swift
//  BTCPriceLoaderApp
//
//  Created by Damian Modernell on 26/1/25.
//

import Foundation
import BTCLoader

struct BTCLoaderAdapter {
    let loader: BTCPriceLoadable
    let btcPriceViewModel: BTCPriceViewModel
    let btcPriceErrorViewModel: BTCPriceErrorViewModel
    
    func load() async {
        do {
            let btcPrice = try await loader.loadBTCPrice()
            btcPriceErrorViewModel.hideBTCLoadError(at: .now)
            btcPriceViewModel.btcPrice = BTCPriceViewRepresentation(
                price: "\(btcPrice.amount)",
                color: .black
            )
        } catch {
            btcPriceErrorViewModel.displayBTCLoadError()
        }
    }
}
