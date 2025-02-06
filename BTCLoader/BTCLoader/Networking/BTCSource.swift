//
//  BTCSource.swift
//  BTCLoader
//
//  Created by Damian Modernell on 24/1/25.
//

enum BTCSource {
    case binance
    case coinbase
    case bybit

    var url: URL {
        switch self {
        case .binance: URL(
                string: "https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT"
            )!
        case .coinbase: URL(
                string: "https://min-api.cryptocompare.com/data/generateAvg?fsym=BTC&tsym=USD&e=coinbase"
            )!
        case .bybit:
            URL(
                string: "https://api-testnet.bybit.com/v5/market/tickers?category=inverse&symbol=BTCUSDT"
            )!
        }
    }

    var mapper: Mapper {
        switch self {
        case .binance: BinanceBTCLoaderMapper.map
        case .coinbase: CoinbaseBTCLoaderMapper.map
        case .bybit: BybitBTCLoaderMapper.map
        }
    }
}
