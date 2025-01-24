//
//  HTTPClient.swift
//  BTCLoader
//
//  Created by Damian Modernell on 23/1/25.
//

enum HTTPClientError: Error {
    case timeout
}

protocol HTTPClient {
    func load(url: URL) async throws(HTTPClientError) -> (HTTPURLResponse, Data)
}
