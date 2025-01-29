//
//  RemoteBTCPriceLoadable.swift
//  BTCLoader
//
//  Created by Damian Modernell on 24/1/25.
//

public enum RemoteBTCPriceLoaderError: Error {
    case decoding
    case connectivity
}

protocol RemoteBTCPriceLoadable {
    func loadRemoteBTCPrice() async throws(RemoteBTCPriceLoaderError) -> RemoteBTCPrice
}
