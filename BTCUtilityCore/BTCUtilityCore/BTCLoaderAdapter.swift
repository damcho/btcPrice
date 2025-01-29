//
//  BTCLoaderAdapter.swift
//  BTCPriceLoaderApp
//
//  Created by Damian Modernell on 26/1/25.
//

import Foundation
import BTCLoader

public protocol BTCPriceErrorDisplayable {
    func displayBTCLoadError(for timestamp: Date?)
}

public protocol BTCPriceErrorRemovable {
    func hideBTCLoadError()
}

public protocol BTCPriceDisplayable {
    func display(_ btcPrice: BTCPrice)
}

final class BTCLoaderAdapter {
    let loader: BTCPriceLoadable
    let btcPriceDisplayable: BTCPriceDisplayable
    let btcPriceErrorRemovable: BTCPriceErrorRemovable?
    let btcPriceErrorDisplayable: BTCPriceErrorDisplayable

    private var lastBTCUpdatedTimestamp: Date?
    
    init(
        loader: BTCPriceLoadable,
        btcPriceDisplayable: BTCPriceDisplayable,
        btcPriceErrorDisplayable: BTCPriceErrorDisplayable,
        btcPriceErrorRemovable: BTCPriceErrorRemovable? = nil
    ) {
        self.loader = loader
        self.btcPriceDisplayable = btcPriceDisplayable
        self.btcPriceErrorRemovable = btcPriceErrorRemovable
        self.btcPriceErrorDisplayable = btcPriceErrorDisplayable
    }
    
    func load() -> Task<Void, Never> {
        Task {
            do {
                let newBTCPrice = try await loader.loadBTCPrice()
                lastBTCUpdatedTimestamp = .now
                await MainActor.run {
                    btcPriceErrorRemovable?.hideBTCLoadError()
                    btcPriceDisplayable.display(newBTCPrice)
                }
            } catch {
                await MainActor.run {
                    btcPriceErrorDisplayable.displayBTCLoadError(
                        for: lastBTCUpdatedTimestamp
                    )
                }
            }
        }
    }
}
