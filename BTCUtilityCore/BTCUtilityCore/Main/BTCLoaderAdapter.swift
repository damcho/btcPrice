//
//  BTCLoaderAdapter.swift
//  BTCPriceLoaderApp
//
//  Created by Damian Modernell on 26/1/25.
//

import BTCLoader
import Foundation

final class BTCLoaderAdapter {
    let loader: BTCPriceLoadable
    let btcPriceDisplayable: BTCPriceDisplayable
    let btcPriceErrorRemovable: BTCPriceErrorRemovable?

    init(
        loader: BTCPriceLoadable,
        btcPriceDisplayable: BTCPriceDisplayable,
        btcPriceErrorRemovable: BTCPriceErrorRemovable? = nil
    ) {
        self.loader = loader
        self.btcPriceDisplayable = btcPriceDisplayable
        self.btcPriceErrorRemovable = btcPriceErrorRemovable
    }

    func load() async throws {
        try await btcPriceDisplayable.display(loader.loadBTCPrice())
        btcPriceErrorRemovable?.hideBTCLoadError()
    }
}
