//
//  BTCLoaderTests.swift
//  BTCLoaderTests
//
//  Created by Damian Modernell on 23/1/25.
//

@testable import BTCLoader
import XCTest

struct BTCPrice: Equatable {}

enum RemoteBTCPriceLoaderError: Error {
    case decding
}

protocol HTTPClient {
    func load(url: URL) async throws -> (HTTPURLResponse, Data)
}

struct RemoteBTCPriceLoader {
    let httpClient: HTTPClient
    let url: URL
    let map: ((response: HTTPURLResponse, data: Data)) throws -> BTCPrice
    
    func loadBTCPrice() async throws(RemoteBTCPriceLoaderError) -> BTCPrice {
        do {
            return try await map(httpClient.load(url: url))
        } catch {
            throw .decding
        }
    }
}

final class BTCLoaderTests: XCTestCase {
    func test_throws_error_on_mapping_failure() async {
        let sut = makeSUT { _, _ in
            throw anyError
        }

        await XCTAssertThrowsError(
            try await sut.loadBTCPrice()
        )
    }
    
    func test_btc_price_on_successful_mapping() async throws {
        let expectedBTCPrice = anyBTCPrice
        let sut = makeSUT(
            for: BTCMapperStub(
                result: .success(expectedBTCPrice)
            ).success(httpResponse:data:)
        )
        
        let actualBTCPrice = try await sut.loadBTCPrice()
        
        XCTAssertEqual(actualBTCPrice, expectedBTCPrice)
    }
}

extension BTCLoaderTests {
    func makeSUT(
        for mapper: @escaping (HTTPURLResponse, Data) throws -> BTCPrice = {_, _ in anyBTCPrice},
        httpResult: Result<(HTTPURLResponse, Data), Error> = .success((anyHTTPResponse, anyData))
    ) -> RemoteBTCPriceLoader {
        RemoteBTCPriceLoader(
            httpClient: HTTPClientStub(result: httpResult),
            url: anyURL,
            map: mapper
        )
    }
}

var anyBTCPrice: BTCPrice {
    BTCPrice()
}

var anyData: Data {
    Data()
}

var anyError: Error {
    NSError(domain: "any error", code: 1)
}

var anyURL: URL {
    URL(string: "https://example.com")!
}

var anyHTTPResponse: HTTPURLResponse {
    HTTPURLResponse(
        url: anyURL,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
    )!
}

struct BTCMapperStub {
    let result: Result<BTCPrice, Error>
    func success(httpResponse: HTTPURLResponse, data: Data) throws -> BTCPrice {
        try result.get()
    }
}

struct HTTPClientStub: HTTPClient {
    let result: Result<(HTTPURLResponse, Data), Error>
    func load(url: URL) async throws -> (HTTPURLResponse, Data) {
        try result.get()
    }
}
