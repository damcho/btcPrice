//
//  RemoteBTCPriceLoaderWithFallbackDecoratorTests.swift
//  BTCLoaderTests
//
//  Created by Damian Modernell on 23/1/25.
//

import XCTest
@testable import BTCLoader

protocol BTCPriceLoadable {
    func loadBTCPrice() async throws(RemoteBTCPriceLoaderError) -> BTCPrice
}

struct RemoteBTCPriceLoaderWithFallbackDecorator {
    let primaryLoader: BTCPriceLoadable
    let secodaryLoader: BTCPriceLoadable
    
    init (
        primaryLoader: BTCPriceLoadable,
        secondaryLoader: BTCPriceLoadable
    ) {
        self.primaryLoader = primaryLoader
        self.secodaryLoader = secondaryLoader
    }
}

extension RemoteBTCPriceLoaderWithFallbackDecorator: BTCPriceLoadable {
    func loadBTCPrice() async throws(RemoteBTCPriceLoaderError) -> BTCPrice {
        do {
            return try await primaryLoader.loadBTCPrice()
        } catch {
            return try await secodaryLoader.loadBTCPrice()
        }
    }
}

final class RemoteBTCPriceLoaderWithFallbackDecoratorTests: XCTestCase {

    func test_loads_btc_price_on_primary_loader_success() async throws {
        let primaryBTCPrice = BTCPrice(amount: 100, currency: .USD)
        let secondaryBTCPrice = BTCPrice(amount: 99, currency: .USD)

        let sut = makeSUT(
            primaryLoaderResult: .success(primaryBTCPrice),
            secondaryLoaderResult: .success(secondaryBTCPrice)
        )
        
        let result = try await sut.loadBTCPrice()
        
        XCTAssertEqual(result, primaryBTCPrice)
    }
    
    func test_secondary_btc_price_on_primary_load_failure() async throws {
        let secondaryBTCPrice = BTCPrice(amount: 99, currency: .USD)

        let sut = makeSUT(
            primaryLoaderResult: .failure(.connectivity),
            secondaryLoaderResult: .success(secondaryBTCPrice)
        )
        
        let result = try await sut.loadBTCPrice()
        
        XCTAssertEqual(result, secondaryBTCPrice)
    }
    
    func test_throws_on_primary_and_secondary_loader_failure() async throws {
        let sut = makeSUT(
            primaryLoaderResult: .failure(.connectivity),
            secondaryLoaderResult: .failure(.connectivity)
        )
        
        await XCTAssertThrowsError(
            try await sut.loadBTCPrice()
        ) { error in
            XCTAssertEqual(error as? RemoteBTCPriceLoaderError, .connectivity)
        }
    }
}

extension RemoteBTCPriceLoaderWithFallbackDecoratorTests {
    func makeSUT(
        primaryLoaderResult: Result<BTCPrice, RemoteBTCPriceLoaderError>,
        secondaryLoaderResult: Result<BTCPrice, RemoteBTCPriceLoaderError>
    ) -> BTCPriceLoadable {
        RemoteBTCPriceLoaderWithFallbackDecorator(
            primaryLoader: BTCPriceLoadableStub(stubResult: primaryLoaderResult),
            secondaryLoader: BTCPriceLoadableStub(stubResult: secondaryLoaderResult)
        )
    }
}

struct BTCPriceLoadableStub: BTCPriceLoadable {
    let stubResult: Result<BTCPrice, RemoteBTCPriceLoaderError>
    func loadBTCPrice() async throws(RemoteBTCPriceLoaderError) -> BTCPrice {
        try stubResult.get()
    }
}
