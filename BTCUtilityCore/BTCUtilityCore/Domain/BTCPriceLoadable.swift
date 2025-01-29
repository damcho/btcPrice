//
//  BTCPriceLoadable.swift
//  BTCLoader
//
//  Created by Damian Modernell on 24/1/25.
//

public enum BTCPriceLoaderError: Error {
    case decoding
    case connectivity
}

public protocol BTCPriceLoadable {
    func loadBTCPrice() async throws(BTCPriceLoaderError) -> BTCPrice
}
