//
//  Helpers.swift
//  BTCLoaderTests
//
//  Created by Damian Modernell on 6/2/25.
//

import Foundation
@testable import BTCLoader

var anyBinanceBTCPrice: (decoded: RemoteBTCPrice, encoded: Data) {
    (
        RemoteBTCPrice(amount: 104593.190, currency: .USD),
        #"{"symbol":"BTCUSDT","price":"104593.19000000"}"#.data(using: .utf8)!
    )
}

var anyCoinbaseBTCPrice: (decoded: RemoteBTCPrice, encoded: Data) {
    (
        RemoteBTCPrice(amount: 103457.51, currency: .USD),
        #"{"DISPLAY": {"PRICE": "$ 103,457.51"}}"#.data(using: .utf8)!
    )
}

var anyBybitBTCPrice: (decoded: RemoteBTCPrice, encoded: Data) {
    (
        RemoteBTCPrice(amount: 96081.38, currency: .USD),
        #"{"result": {"list": [{"symbol": "BTCUSDT","indexPrice": "96081.38"}]}}"#.data(using: .utf8)!
    )
}

var anyInvalidEncodedBTCPrice: (decoded: RemoteBTCPrice, encoded: Data) {
    (
        RemoteBTCPrice(amount: 103457.51, currency: .USD),
        "invalid-btc-price".data(using: .utf8)!
    )
}
