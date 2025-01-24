//
//  RemoteBTCPriceLoader.swift
//  BTCLoader
//
//  Created by Damian Modernell on 23/1/25.
//

public enum RemoteBTCPriceLoaderError: Error {
    case decoding
    case connectivity
}

struct RemoteBTCPriceLoader {
    let httpClient: HTTPClient
    let url: URL
    let map: ((response: HTTPURLResponse, data: Data)) throws -> BTCPrice
}

// MARK: BTCPriceLoadable

extension RemoteBTCPriceLoader: BTCPriceLoadable {
    func loadBTCPrice() async throws(RemoteBTCPriceLoaderError) -> BTCPrice {
        do {
            return try await map(httpClient.load(url: url))
        } catch is HTTPClientError {
            throw .connectivity
        } catch {
            throw .decoding
        }
    }
}
