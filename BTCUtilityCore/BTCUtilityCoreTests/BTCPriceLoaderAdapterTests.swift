//
//  BTCPriceLoaderAdapterTests.swift
//  BTCPriceLoaderAppTests
//
//  Created by Damian Modernell on 26/1/25.
//

import BTCLoader
@testable import BTCUtilityCore
import XCTest
import TestHelpers

final class BTCPriceLoaderAdapterTests: XCTestCase {
    func test_displays_btc_price_on_successful_load() async throws {
        let (sut, btcPriceDisplayableSpy, _) = await makeSUT(
            btcloadableStub: .success(anyBTCPrice)
        )

        try await sut.load()

        XCTAssertEqual(
            btcPriceDisplayableSpy.displayableMessages,
            [.success(anyBTCPrice), .hideError]
        )
    }

    func test_hides_error_on_successful_btc_price_load() async throws {
        let (sut, btcPriceDisplayableSpy, _) = await makeSUT(
            btcloadableStub: .success(anyBTCPrice)
        )
        XCTAssertEqual(btcPriceDisplayableSpy.displayableMessages, [])

        try await sut.load()

        XCTAssertEqual(
            btcPriceDisplayableSpy.displayableMessages,
            [.success(anyBTCPrice), .hideError]
        )
    }

    func test_throws_on_btc_price_load_failure() async throws {
        let (sut, _, _) = await makeSUT(
            btcloadableStub: .failure(.connectivity)
        )

        await AsyncXCTAssertThrowsError(
            try await sut.load()
        )
    }
}

extension BTCPriceLoaderAdapterTests {
    @MainActor private func makeSUT(
        btcloadableStub: Result<BTCPrice, BTCPriceLoaderError>
    )
        -> (BTCLoaderAdapter, BTCPriceDisplayableSpy, BTCPriceLoadableStub)
    {
        let btcDisplayableSpy = BTCPriceDisplayableSpy()

        let btcLoadableStub = BTCPriceLoadableStub(
            stub: btcloadableStub
        )
        let loaderAdapter = BTCLoaderAdapter(
            loader: btcLoadableStub,
            btcPriceDisplayable: btcDisplayableSpy,
            btcPriceErrorRemovable: btcDisplayableSpy
        )
        trackForMemoryLeaks(loaderAdapter)
        trackForMemoryLeaks(btcLoadableStub)
        trackForMemoryLeaks(btcDisplayableSpy)

        return (loaderAdapter, btcDisplayableSpy, btcLoadableStub)
    }
}

class BTCPriceDisplayableSpy: BTCPriceDisplayable, BTCPriceErrorRemovable {
    var displayableMessages: [BTCDisplayable] = []
    var didDisplayError = false
    var displayable: BTCPrice?
    func display(_ price: BTCPrice) {
        displayableMessages.append(.success(price))
    }

    func hideBTCLoadError() {
        displayableMessages.append(.hideError)
    }
}

enum BTCDisplayable: Equatable {
    case error(Date?)
    case success(BTCPrice)
    case hideError
}

class BTCPriceLoadableStub: BTCPriceLoadable {
    var stub: Result<BTCPrice, BTCPriceLoaderError>
    init(stub: Result<BTCPrice, BTCPriceLoaderError>) {
        self.stub = stub
    }

    func loadBTCPrice() async throws(BTCPriceLoaderError) -> BTCPrice {
        try stub.get()
    }
}

var anyBTCPrice: BTCPrice {
    BTCPrice(amount: 10, currency: .USD)
}
