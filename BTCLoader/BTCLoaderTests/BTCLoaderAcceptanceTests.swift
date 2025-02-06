//
//  BTCLoaderAcceptanceTests.swift
//  BTCLoaderTests
//
//  Created by Damian Modernell on 24/1/25.
//

import XCTest
@testable import BTCLoader

final class BTCLoaderAcceptanceTests: XCTestCase {

    func test_returns_btc_price_on_succesful_binance_primary_loader_source() async throws {
        let sut = makeSUT(
            primaryLoader: RemoteBTCPriceLoaderUtility.binanceLoader(
                with: HTTPClientStub(
                    result: .success((validHTTPResponse, anyBinanceBTCPrice.encoded))
                )
            )
        )
        
        let result = try await sut.loadRemoteBTCPrice()
        
        XCTAssertEqual(result, anyBinanceBTCPrice.decoded)
    }
    
    func test_returns_btc_price_on_succesful_coinbase_secondary_loader_source() async throws {
        let sut = makeSUT(
            secondaryLoader: RemoteBTCPriceLoaderUtility.coinbaseLoader(
                with: HTTPClientStub(
                    result: .success((validHTTPResponse, anyCoinbaseBTCPrice.encoded))
                )
            )
        )
        
        let result = try await sut.loadRemoteBTCPrice()
        
        XCTAssertEqual(result, anyCoinbaseBTCPrice.decoded)
    }
    
    func test_throws_on_all_loaders_failure() async throws {
        let sut = makeSUT()
        
        await AsyncXCTAssertThrowsError(
            _ = try await sut.loadRemoteBTCPrice()
        ) { error in
            XCTAssertEqual(error as? RemoteBTCPriceLoaderError, .connectivity)
        }
    }
    
    func test_returns_btc_price_on_succesful_bybit_loader_source() async throws {
        let sut = makeSUT(
            thirdLoader: RemoteBTCPriceLoaderUtility.bybitLoader(
                with: HTTPClientStub(
                    result: .success((validHTTPResponse, anyBybitBTCPrice.encoded))
                )
            )
        )
        
        let result = try await sut.loadRemoteBTCPrice()
        
        XCTAssertEqual(result, anyBybitBTCPrice.decoded)
    }
}

extension BTCLoaderAcceptanceTests {
    private func makeSUT(
        primaryLoader: RemoteBTCPriceLoadable = BTCPriceLoadableStub(stubResult: .failure(.connectivity)),
        secondaryLoader: RemoteBTCPriceLoadable = BTCPriceLoadableStub(stubResult: .failure(.connectivity)),
        thirdLoader: RemoteBTCPriceLoadable = BTCPriceLoadableStub(stubResult: .failure(.connectivity))
    ) -> RemoteBTCPriceLoadable {
        RemoteBTCPriceLoaderWithFallbackDecorator(
            primaryLoader: RemoteBTCPriceLoaderWithFallbackDecorator(
                primaryLoader: primaryLoader,
                secondaryLoader: secondaryLoader
            ),
            secondaryLoader: thirdLoader
        )
    }
}


