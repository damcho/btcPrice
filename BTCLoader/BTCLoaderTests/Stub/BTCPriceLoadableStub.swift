//
//  BTCPriceLoadableStub.swift
//  BTCLoaderTests
//
//  Created by Damian Modernell on 6/2/25.
//

@testable import BTCLoader

struct BTCPriceLoadableStub: RemoteBTCPriceLoadable {
    let stubResult: Result<RemoteBTCPrice, RemoteBTCPriceLoaderError>
    func loadRemoteBTCPrice() async throws(RemoteBTCPriceLoaderError) -> RemoteBTCPrice {
        try stubResult.get()
    }
}
