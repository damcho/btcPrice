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

    static func compose(
        primaryLoader: RemoteBTCPriceLoadable,
        secondaryLoader: RemoteBTCPriceLoadable,
        thirdLoader: RemoteBTCPriceLoadable
    )
        -> RemoteBTCPriceLoaderWithFallbackDecorator
    {
        RemoteBTCPriceLoaderWithFallbackDecorator(
            primaryLoader: RemoteBTCPriceLoaderWithFallbackDecorator(
                primaryLoader: primaryLoader,
                secondaryLoader: secondaryLoader
            ),
            secondaryLoader: thirdLoader
        )
    }

    public static func makeLoader(
        with httpClient: HTTPClient
    )
        -> RemoteBTCPriceLoaderWithFallbackDecorator
    {
        compose(
            primaryLoader: binanceLoader(with: httpClient),
            secondaryLoader: coinbaseLoader(with: httpClient),
            thirdLoader: bybitLoader(with: httpClient)
        )
    }
}
