//
//  BTCPriceLoadable.swift
//  BTCLoader
//
//  Created by Damian Modernell on 24/1/25.
//

protocol BTCPriceLoadable {
    func loadBTCPrice() async throws(RemoteBTCPriceLoaderError) -> BTCPrice
}
