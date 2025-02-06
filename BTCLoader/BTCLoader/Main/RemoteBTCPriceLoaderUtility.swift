//
//  RemoteBTCPriceLoaderUtility.swift
//  BTCLoader
//
//  Created by Damian Modernell on 24/1/25.
//

public enum RemoteBTCPriceLoaderUtility {
    static func binanceLoader(
        with httpClient: HTTPClient
    )
        -> RemoteBTCPriceLoadable
    {
        RemoteBTCPriceLoader(
            httpClient: httpClient,
            url: BTCSource.binance.url,
            map: BTCSource.binance.mapper
        )
    }

    static func coinbaseLoader(
        with httpClient: HTTPClient
    )
        -> RemoteBTCPriceLoadable
    {
        RemoteBTCPriceLoader(
            httpClient: httpClient,
            url: BTCSource.coinbase.url,
            map: BTCSource.coinbase.mapper
        )
    }

    static func bybitLoader(
        with httpClient: HTTPClient
    )
        -> RemoteBTCPriceLoadable
    {
        RemoteBTCPriceLoader(
            httpClient: httpClient,
            url: BTCSource.bybit.url,
            map: BTCSource.bybit.mapper
        )
    }

    public static func makeLoader(
        with httpClient: HTTPClient
    )
        -> RemoteBTCPriceLoaderWithFallbackDecorator
    {
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
