//
//  URLSessionHTTPClient+HTTPClientExtension.swift
//  BTCPriceLoaderApp
//
//  Created by Damian Modernell on 28/1/25.
//
import BTCLoader
import Networking

extension URLSessionHTTPClient: @retroactive HTTPClient {
    public func load(url: URL) async throws(HTTPClientError) -> (HTTPURLResponse, Data) {
        let result = await withCheckedContinuation { continuation in
            _ = get(from: url) { result in
                continuation.resume(returning: result)
            }
        }

        do {
            let aResult = try result.get()
            return (aResult.1, aResult.0)
        } catch {
            throw .timeout
        }
    }
}
