//
//  HTTPClientStub.swift
//  BTCLoaderTests
//
//  Created by Damian Modernell on 6/2/25.
//

@testable import BTCLoader

struct HTTPClientStub: HTTPClient {
    let result: Result<(HTTPURLResponse, Data), HTTPClientError>
    func load(url: URL) async throws(HTTPClientError) -> (HTTPURLResponse, Data) {
        try result.get()
    }
}
