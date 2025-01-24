//
//  BTCLoaderAcceptanceTests.swift
//  BTCLoaderTests
//
//  Created by Damian Modernell on 24/1/25.
//

import XCTest
@testable import BTCLoader

final class BTCLoaderAcceptanceTests: XCTestCase {

    func test_returns_btc_price_on_succesful_primary_loader_source() async throws {
        let sut = makeSUT(
            primaryLoaderHTTPResult: .success((validHTTPResponse, anyBTCPrice.encoded)),
            secondaryLoaderHTTPResult: .failure(.timeout)
        )
        
        let result = try await sut.loadBTCPrice()
        
        XCTAssertEqual(result, anyBTCPrice.decoded)
    }
    
    func test_returns_btc_price_on_succesful_secondary_loader_source() async throws {
        let sut = makeSUT(
            primaryLoaderHTTPResult: .failure(.timeout),
            secondaryLoaderHTTPResult: .success((validHTTPResponse, anyBTCPrice.encoded))
        )
        
        let result = try await sut.loadBTCPrice()
        
        XCTAssertEqual(result, anyBTCPrice.decoded)
    }
    
    func test_throws_on_all_loaders_failure() async throws {
        let sut = makeSUT(
            primaryLoaderHTTPResult: .failure(.timeout),
            secondaryLoaderHTTPResult: .failure(.timeout)
        )
        
        await AsyncXCTAssertThrowsError(
            _ = try await sut.loadBTCPrice()
        ) { error in
            XCTAssertEqual(error as? RemoteBTCPriceLoaderError, .connectivity)
        }
    }
}

extension BTCLoaderAcceptanceTests {
    private func makeSUT(
        primaryLoaderHTTPResult: Result<((HTTPURLResponse, Data)), HTTPClientError>,
        secondaryLoaderHTTPResult: Result<((HTTPURLResponse, Data)), HTTPClientError>
    ) -> BTCPriceLoadable {
        RemoteBTCPriceLoaderWithFallbackDecorator(
            primaryLoader: RemoteBTCPriceLoader(
                httpClient: HTTPClientStub(
                    result: primaryLoaderHTTPResult
                ),
                url: anyURL,
                map: BinanceBTCLoaderMapper.map
            ),
            secondaryLoader: RemoteBTCPriceLoader(
                httpClient: HTTPClientStub(
                    result: secondaryLoaderHTTPResult
                ),
                url: anyURL,
                map: BinanceBTCLoaderMapper.map
            )
        )
    }
    
    var anyBTCPrice: (decoded: BTCPrice, encoded: Data) {
        (
            BTCPrice(amount: 104593.190, currency: .USD),
            #"{"symbol":"BTCUSDT","price":"104593.19000000"}"#.data(using: .utf8)!
        )
    }
}


