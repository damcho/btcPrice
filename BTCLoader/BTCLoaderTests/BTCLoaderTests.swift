//
//  BTCLoaderTests.swift
//  BTCLoaderTests
//
//  Created by Damian Modernell on 23/1/25.
//

@testable import BTCLoader
import XCTest

final class BTCLoaderTests: XCTestCase {
    func test_throws_decoding_error_on_mapping_failure() async {
        let sut = makeSUT(
            for: {_, _ in throw RemoteBTCPriceLoaderError.decoding }
        )

        await XCTAssertThrowsError(
            try await sut.loadBTCPrice()
        ){ error in
            XCTAssertEqual(error as? RemoteBTCPriceLoaderError, RemoteBTCPriceLoaderError.decoding)
        }
    }
    
    func test_throws_connectivity_error_on_http_response_failure() async {
        let sut = makeSUT(
            httpResult: .failure(anyHTTPError)
        )
        await XCTAssertThrowsError(
            try await sut.loadBTCPrice()
        ) { error in
            XCTAssertEqual(error as? RemoteBTCPriceLoaderError, RemoteBTCPriceLoaderError.connectivity)
        }
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
        httpResult: Result<(HTTPURLResponse, Data), HTTPClientError> = .success((anyHTTPResponse, anyData))
    ) -> RemoteBTCPriceLoader {
        RemoteBTCPriceLoader(
            httpClient: HTTPClientStub(result: httpResult),
            url: anyURL,
            map: mapper
        )
    }
}

var anyBTCPrice: BTCPrice {
    BTCPrice(amount: 10.0, currency: .USD)
}

var anyData: Data {
    Data()
}

var anyHTTPError: HTTPClientError {
    .timeout
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
    let result: Result<BTCPrice, RemoteBTCPriceLoaderError>
    func success(httpResponse: HTTPURLResponse, data: Data) throws(RemoteBTCPriceLoaderError) -> BTCPrice {
        try result.get()
    }
}

struct HTTPClientStub: HTTPClient {
    let result: Result<(HTTPURLResponse, Data), HTTPClientError>
    func load(url: URL) async throws(HTTPClientError) -> (HTTPURLResponse, Data) {
        try result.get()
    }
}
