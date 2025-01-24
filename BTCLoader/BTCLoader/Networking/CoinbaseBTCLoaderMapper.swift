//
//  CoinbaseBTCLoaderMapper.swift
//  BTCLoader
//
//  Created by Damian Modernell on 24/1/25.
//

enum CoinbaseBTCLoaderMapper {
    struct CoinbaseBTCPrice: Decodable {
        let display: PriceData

        enum CodingKeys: String, CodingKey {
            case display = "DISPLAY"
        }

        func toBTCPrice() throws -> BTCPrice {
            let trimmedDisplay = display.price.replacingOccurrences(of: " ", with: "")
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "en_US")
            formatter.numberStyle = .currency
            guard let aPrice = formatter.number(from: trimmedDisplay) else {
                throw RemoteBTCPriceLoaderError.decoding
            }
            return BTCPrice(amount: Double(truncating: aPrice), currency: .USD)
        }
    }

    struct PriceData: Decodable {
        let price: String

        enum CodingKeys: String, CodingKey {
            case price = "PRICE"
        }
    }

    static func map(_ response: HTTPURLResponse, _ data: Data) throws -> BTCPrice {
        guard response.statusCode == 200 else {
            throw RemoteBTCPriceLoaderError.connectivity
        }
        let coinbaseBTCPrice = try JSONDecoder().decode(
            CoinbaseBTCPrice.self,
            from: data
        )
        return try coinbaseBTCPrice.toBTCPrice()
    }
}
