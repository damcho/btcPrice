//
//  BTCSource.swift
//  BTCLoader
//
//  Created by Damian Modernell on 24/1/25.
//

enum BTCSource {
    case binance
    case coinbase

    var url: URL {
        switch self {
        case .binance: URL(
                string: "https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT"
            )!
        case .coinbase: URL(
                string: "https://min-api.cryptocompare.com/data/generateAvg?fsym=BTC&tsym=USD&e=coinbase"
            )!
        }
    }

    var mapper: Mapper {
        switch self {
        case .binance: BinanceBTCLoaderMapper.map
        case .coinbase: CoinbaseBTCLoaderMapper.map
        }
    }
}
