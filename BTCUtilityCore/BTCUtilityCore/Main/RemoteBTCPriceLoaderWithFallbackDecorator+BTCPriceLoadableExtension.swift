//
//  RemoteBTCPriceLoaderWithFallbackDecorator+BTCPriceLoadableExtension.swift
//  BTCUtilityCore
//
//  Created by Damian Modernell on 29/1/25.
//

import BTCLoader
import Foundation

// MARK: - RemoteBTCPriceLoaderWithFallbackDecorator + BTCPriceLoadable

extension RemoteBTCPriceLoaderWithFallbackDecorator: BTCPriceLoadable {
    public func loadBTCPrice() async throws(BTCPriceLoaderError) -> BTCPrice {
        do {
            return try await loadRemoteBTCPrice().toBTCPrice()
        } catch {
            throw .connectivity
        }
    }
}

extension RemoteBTCPrice {
    func toBTCPrice() -> BTCPrice {
        BTCPrice(
            amount: amount,
            currency: Currency.USD
        )
    }
}
