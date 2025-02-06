//
//  BTCMapperStub.swift
//  BTCLoaderTests
//
//  Created by Damian Modernell on 6/2/25.
//

@testable import BTCLoader

struct BTCMapperStub {
    let result: Result<RemoteBTCPrice, RemoteBTCPriceLoaderError>
    func success(httpResponse: HTTPURLResponse, data: Data) throws(RemoteBTCPriceLoaderError) -> RemoteBTCPrice {
        try result.get()
    }
}
