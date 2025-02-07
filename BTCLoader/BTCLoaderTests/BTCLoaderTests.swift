//
//  BTCLoaderTests.swift
//  BTCLoaderTests
//
//  Created by Damian Modernell on 23/1/25.
//

@testable import BTCLoader
import XCTest
import TestHelpers

final class BTCLoaderTests: XCTestCase {
    func test_throws_decoding_error_on_mapping_failure() async {
        let sut = makeSUT(
            for: {_, _ in throw RemoteBTCPriceLoaderError.decoding }
        )

        await AsyncXCTAssertThrowsError(
            try await sut.loadRemoteBTCPrice()
        ){ error in
            XCTAssertEqual(error as? RemoteBTCPriceLoaderError, RemoteBTCPriceLoaderError.decoding)
        }
    }
    
    func test_throws_connectivity_error_on_http_response_failure() async {
        let sut = makeSUT(
            httpResult: .failure(anyHTTPError)
        )
        await AsyncXCTAssertThrowsError(
            try await sut.loadRemoteBTCPrice()
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
        
        let actualBTCPrice = try await sut.loadRemoteBTCPrice()
        
        XCTAssertEqual(actualBTCPrice, expectedBTCPrice)
    }
}

extension BTCLoaderTests {
    func makeSUT(
        for mapper: @escaping (HTTPURLResponse, Data) throws -> RemoteBTCPrice = {_, _ in anyBTCPrice},
        httpResult: Result<(HTTPURLResponse, Data), HTTPClientError> = .success((validHTTPResponse, anyData))
    ) -> RemoteBTCPriceLoader {
        RemoteBTCPriceLoader(
            httpClient: HTTPClientStub(result: httpResult),
            url: anyURL,
            map: mapper
        )
    }
}

