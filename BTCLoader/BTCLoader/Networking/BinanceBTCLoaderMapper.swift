//
//  BinanceBTCLoaderMapper.swift
//  BTCLoader
//
//  Created by Damian Modernell on 24/1/25.
//

enum BinanceBTCLoaderMapper {
    struct BinanceBTCPrice: Decodable {
        let price: String

        func toBTCPrice() throws -> BTCPrice {
            guard let aPrice = Double(price) else {
                throw RemoteBTCPriceLoaderError.decoding
            }
            return BTCPrice(amount: aPrice, currency: .USD)
        }
    }

    static func map(http: (response: HTTPURLResponse, data: Data)) throws -> BTCPrice {
        guard http.response.statusCode == 200 else {
            throw RemoteBTCPriceLoaderError.connectivity
        }
        let binanceBTCPrice = try JSONDecoder().decode(
            BinanceBTCPrice.self,
            from: http.data
        )
        return try binanceBTCPrice.toBTCPrice()
    }
}
