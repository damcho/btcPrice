//
//  RemoteBTCPriceLoaderWithFallbackDecoratorTests.swift
//  BTCLoaderTests
//
//  Created by Damian Modernell on 23/1/25.
//

import XCTest
@testable import BTCLoader

final class RemoteBTCPriceLoaderWithFallbackDecoratorTests: XCTestCase {

    func test_loads_btc_price_on_primary_loader_success() async throws {
        let primaryBTCPrice = RemoteBTCPrice(amount: 100, currency: .USD)
        let secondaryBTCPrice = RemoteBTCPrice(amount: 99, currency: .USD)

        let sut = makeSUT(
            primaryLoaderResult: .success(primaryBTCPrice),
            secondaryLoaderResult: .success(secondaryBTCPrice)
        )
        
        let result = try await sut.loadRemoteBTCPrice()
        
        XCTAssertEqual(result, primaryBTCPrice)
    }
    
    func test_secondary_btc_price_on_primary_load_failure() async throws {
        let secondaryBTCPrice = RemoteBTCPrice(amount: 99, currency: .USD)

        let sut = makeSUT(
            primaryLoaderResult: .failure(.connectivity),
            secondaryLoaderResult: .success(secondaryBTCPrice)
        )
        
        let result = try await sut.loadRemoteBTCPrice()
        
        XCTAssertEqual(result, secondaryBTCPrice)
    }
    
    func test_throws_on_primary_and_secondary_loader_failure() async throws {
        let sut = makeSUT(
            primaryLoaderResult: .failure(.connectivity),
            secondaryLoaderResult: .failure(.connectivity)
        )
        
        await AsyncXCTAssertThrowsError(
            try await sut.loadRemoteBTCPrice()
        ) { error in
            XCTAssertEqual(error as? RemoteBTCPriceLoaderError, .connectivity)
        }
    }
}

extension RemoteBTCPriceLoaderWithFallbackDecoratorTests {
    func makeSUT(
        primaryLoaderResult: Result<RemoteBTCPrice, RemoteBTCPriceLoaderError>,
        secondaryLoaderResult: Result<RemoteBTCPrice, RemoteBTCPriceLoaderError>
    ) -> RemoteBTCPriceLoadable {
        RemoteBTCPriceLoaderWithFallbackDecorator(
            primaryLoader: BTCPriceLoadableStub(stubResult: primaryLoaderResult),
            secondaryLoader: BTCPriceLoadableStub(stubResult: secondaryLoaderResult)
        )
    }
}

struct BTCPriceLoadableStub: RemoteBTCPriceLoadable {
    let stubResult: Result<RemoteBTCPrice, RemoteBTCPriceLoaderError>
    func loadRemoteBTCPrice() async throws(RemoteBTCPriceLoaderError) -> RemoteBTCPrice {
        try stubResult.get()
    }
}
