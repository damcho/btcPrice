//
//  RemoteBTCPriceLoaderWithFallbackDecorator.swift
//  BTCLoader
//
//  Created by Damian Modernell on 24/1/25.
//

struct RemoteBTCPriceLoaderWithFallbackDecorator {
    let primaryLoader: BTCPriceLoadable
    let secodaryLoader: BTCPriceLoadable

    init(
        primaryLoader: BTCPriceLoadable,
        secondaryLoader: BTCPriceLoadable
    ) {
        self.primaryLoader = primaryLoader
        self.secodaryLoader = secondaryLoader
    }
}

// MARK: BTCPriceLoadable

extension RemoteBTCPriceLoaderWithFallbackDecorator: BTCPriceLoadable {
    func loadBTCPrice() async throws(RemoteBTCPriceLoaderError) -> BTCPrice {
        do {
            return try await primaryLoader.loadBTCPrice()
        } catch {
            return try await secodaryLoader.loadBTCPrice()
        }
    }
}
