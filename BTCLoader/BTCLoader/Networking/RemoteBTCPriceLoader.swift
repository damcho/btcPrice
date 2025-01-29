//
//  RemoteBTCPriceLoader.swift
//  BTCLoader
//
//  Created by Damian Modernell on 23/1/25.
//

typealias Mapper = ((HTTPURLResponse, Data)) throws -> RemoteBTCPrice

struct RemoteBTCPriceLoader {
    let httpClient: HTTPClient
    let url: URL
    let map: Mapper
}

// MARK: RemoteBTCPriceLoadable

extension RemoteBTCPriceLoader: RemoteBTCPriceLoadable {
    func loadRemoteBTCPrice() async throws(RemoteBTCPriceLoaderError) -> RemoteBTCPrice {
        do {
            return try await map(httpClient.load(url: url))
        } catch is HTTPClientError {
            throw .connectivity
        } catch {
            throw .decoding
        }
    }
}
