//
//  ByBitBTCLoaderMapper.swift
//  BTCLoader
//
//  Created by Damian Modernell on 6/2/25.
//

import Foundation

enum BybitBTCLoaderMapper {
    struct BybitBTCPrice: Decodable {
        let result: ResultList

        func toBTCPrice() throws -> RemoteBTCPrice {
            guard
                let firstIndexPrice = result.list.first?.indexPrice,
                let aDoublePrice = Double(firstIndexPrice)
            else {
                throw RemoteBTCPriceLoaderError.decoding
            }

            return RemoteBTCPrice(amount: aDoublePrice, currency: .USD)
        }
    }

    struct ResultList: Decodable {
        let list: [BTCPriceInfo]
    }

    struct BTCPriceInfo: Decodable {
        let indexPrice: String
    }

    static func map(http: (response: HTTPURLResponse, data: Data)) throws -> RemoteBTCPrice {
        guard http.response.statusCode == 200 else {
            throw RemoteBTCPriceLoaderError.connectivity
        }
        let bybitBTCPrice = try JSONDecoder().decode(
            BybitBTCPrice.self,
            from: http.data
        )
        return try bybitBTCPrice.toBTCPrice()
    }
}
