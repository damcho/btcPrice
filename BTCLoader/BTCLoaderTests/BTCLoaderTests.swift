//
//  BTCLoaderTests.swift
//  BTCLoaderTests
//
//  Created by Damian Modernell on 23/1/25.
//

@testable import BTCLoader
import XCTest

struct BTCPrice {}

enum RemoteBTCPriceLoaderError: Error {
    case decding
}

struct RemoteBTCPriceLoader {
    func loadBTCPrice() async throws(RemoteBTCPriceLoaderError) -> BTCPrice {
        throw .decding
    }
}

final class BTCLoaderTests: XCTestCase {
    func test_throws_error_on_mapping_failure() async {
        let sut = makeSUT()

        await XCTAssertThrowsError(
            try await sut.loadBTCPrice()
        )
    }
}

extension BTCLoaderTests {
    func makeSUT() -> RemoteBTCPriceLoader {
        RemoteBTCPriceLoader()
    }
}
