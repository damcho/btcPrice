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

    private var lastBTCUpdatedTimestamp: Date?

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
        let newBTCPrice = try await loader.loadBTCPrice()
        lastBTCUpdatedTimestamp = .now
        await MainActor.run {
            btcPriceErrorRemovable?.hideBTCLoadError()
            btcPriceDisplayable.display(newBTCPrice)
        }
    }
}
