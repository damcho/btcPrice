//
//  BTCPriceMainThreadDispatcher.swift
//  BTCPriceLoaderApp
//
//  Created by Damian Modernell on 8/2/25.
//

import BTCUtilityCore
import Foundation

struct BTCPriceMainThreadDispatcher<BTCDisplayable> {
    let decoratee: BTCDisplayable
}

// MARK: BTCPriceDisplayable

extension BTCPriceMainThreadDispatcher: BTCPriceDisplayable where BTCDisplayable == BTCPriceDisplayable {
    func display(_ btcPrice: BTCPrice) {
        Task { @MainActor in
            decoratee.display(btcPrice)
        }
    }
}

// MARK: BTCPriceErrorDisplayable

extension BTCPriceMainThreadDispatcher: BTCPriceErrorDisplayable where BTCDisplayable == BTCPriceErrorDisplayable {
    func displayBTCLoadError(for timestamp: Date?) {
        Task { @MainActor in
            decoratee.displayBTCLoadError(for: timestamp)
        }
    }
}

// MARK: BTCPriceErrorRemovable

extension BTCPriceMainThreadDispatcher: BTCPriceErrorRemovable where BTCDisplayable == BTCPriceErrorRemovable {
    func hideBTCLoadError() {
        Task { @MainActor in
            decoratee.hideBTCLoadError()
        }
    }
}
