//
//  BTCPriceLoaderUtility.swift
//  BTCLoader
//
//  Created by Damian Modernell on 24/1/25.
//

enum BTCPriceLoaderUtility {
    static func binanceLoader(with httpClient: HTTPClient) -> BTCPriceLoadable {
        RemoteBTCPriceLoader(
            httpClient: httpClient,
            url: BTCSource.binance.url,
            map: BTCSource.binance.mapper
        )
    }

    static func coinbaseLoader(with httpClient: HTTPClient) -> BTCPriceLoadable {
        RemoteBTCPriceLoader(
            httpClient: httpClient,
            url: BTCSource.coinbase.url,
            map: BTCSource.coinbase.mapper
        )
    }

    public static func makeLoader(with httpClient: HTTPClient) -> BTCPriceLoadable {
        RemoteBTCPriceLoaderWithFallbackDecorator(
            primaryLoader: binanceLoader(
                with: httpClient
            ),
            secondaryLoader: coinbaseLoader(
                with: httpClient
            )
        )
    }
}
