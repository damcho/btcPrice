//
//  RemoteBTCPriceLoaderWithFallbackDecorator.swift
//  BTCLoader
//
//  Created by Damian Modernell on 24/1/25.
//

public struct RemoteBTCPriceLoaderWithFallbackDecorator {
    let primaryLoader: RemoteBTCPriceLoadable
    let secodaryLoader: RemoteBTCPriceLoadable

    init(
        primaryLoader: RemoteBTCPriceLoadable,
        secondaryLoader: RemoteBTCPriceLoadable
    ) {
        self.primaryLoader = primaryLoader
        self.secodaryLoader = secondaryLoader
    }
}

// MARK: RemoteBTCPriceLoadable

extension RemoteBTCPriceLoaderWithFallbackDecorator: RemoteBTCPriceLoadable {
    public func loadRemoteBTCPrice() async throws(RemoteBTCPriceLoaderError) -> RemoteBTCPrice {
        do {
            return try await primaryLoader.loadRemoteBTCPrice()
        } catch {
            return try await secodaryLoader.loadRemoteBTCPrice()
        }
    }
}
