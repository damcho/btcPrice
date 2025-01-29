//
//  BTCPriceLoaderAcceptanceTests.swift
//  BTCPriceLoaderAppTests
//
//  Created by Damian Modernell on 26/1/25.
//

import BTCLoader
@testable import BTCUtilityCore
import Networking
import XCTest

final class BTCPriceLoaderAcceptanceTests: XCTestCase {
    func test_displays_error_with_no_timestamp_on_load_error() async {
        let (sut, btcPriceDisplayableSpy, _) = makeSUT(
            btcloadableStub: .failure(.connectivity)
        )

        await sut.load().value
        XCTAssertEqual(btcPriceDisplayableSpy.displayableMessages, [.error(nil)])
    }

    func test_displays_btc_price_on_successful_load() async {
        let (sut, btcPriceDisplayableSpy, _) = makeSUT(
            btcloadableStub: .success(anyBTCPrice)
        )

        await sut.load().value

        XCTAssertEqual(
            btcPriceDisplayableSpy.displayableMessages,
            [.hideError, .success(anyBTCPrice)]
        )
    }

    func test_hides_error_on_successful_btc_price_load() async {
        let (sut, btcPriceDisplayableSpy, _) = makeSUT(
            btcloadableStub: .success(anyBTCPrice)
        )
        XCTAssertEqual(btcPriceDisplayableSpy.displayableMessages, [])

        await sut.load().value

        XCTAssertEqual(
            btcPriceDisplayableSpy.displayableMessages,
            [.hideError, .success(anyBTCPrice)]
        )
    }

    func test_hides_error_after_showing_error_and_successful_btc_price_load() async {
        let (sut, btcDisplayableSpy, btcLoadableStub) = makeSUT(
            btcloadableStub: .failure(.connectivity)
        )
        await sut.load().value
        btcLoadableStub.stub = .success(anyBTCPrice)

        await sut.load().value

        XCTAssertEqual(
            btcDisplayableSpy.displayableMessages,
            [.error(nil), .hideError, .success(anyBTCPrice)]
        )
    }

    func test_dispatches_on_main_thread_on_btc_price_load() async {
        await expecttoDispatchOnMainThread(
            forLoaderResult: .failure(
                .connectivity
            )
        )
        await expecttoDispatchOnMainThread(
            forLoaderResult: .success(
                anyBTCPrice
            )
        )
    }

    func test_network_timeout() {
        XCTAssertEqual(URLSessionHTTPClient.oneSecondTimeoutConfiguration.timeoutIntervalForResource, 1)
    }
}

extension BTCPriceLoaderAcceptanceTests {
    private func makeSUT(
        btcloadableStub: Result<BTCPrice, RemoteBTCPriceLoaderError>
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
            btcPriceErrorDisplayable: btcDisplayableSpy,
            btcPriceErrorRemovable: btcDisplayableSpy
        )
        return (loaderAdapter, btcDisplayableSpy, btcLoadableStub)
    }

    private func expecttoDispatchOnMainThread(forLoaderResult: Result<BTCPrice, RemoteBTCPriceLoaderError>) async {
        let (sut, btcDisplayableSpy, _) = makeSUT(
            btcloadableStub: forLoaderResult
        )

        let task = sut.load()
        await task.value

        XCTAssertTrue(btcDisplayableSpy.isMainThread)
    }
}

class BTCPriceDisplayableSpy: BTCPriceDisplayable, BTCPriceErrorDisplayable, BTCPriceErrorRemovable {
    var displayableMessages: [BTCDisplayable] = []
    var isMainThread = false
    var didDisplayError = false
    var displayable: BTCPrice?
    func display(_ price: BTCPrice) {
        isMainThread = Thread.isMainThread
        displayableMessages.append(.success(price))
    }

    func displayBTCLoadError(for timestamp: Date?) {
        isMainThread = Thread.isMainThread
        displayableMessages.append(.error(timestamp))
    }

    func hideBTCLoadError() {
        isMainThread = Thread.isMainThread
        displayableMessages.append(.hideError)
    }
}

enum BTCDisplayable: Equatable {
    case error(Date?)
    case success(BTCPrice)
    case hideError
}

class BTCPriceLoadableStub: BTCPriceLoadable {
    var stub: Result<BTCPrice, RemoteBTCPriceLoaderError>
    init(stub: Result<BTCPrice, RemoteBTCPriceLoaderError>) {
        self.stub = stub
    }

    func loadBTCPrice() async throws(RemoteBTCPriceLoaderError) -> BTCPrice {
        try stub.get()
    }
}

var anyBTCPrice: BTCPrice {
    BTCPrice(amount: 10, currency: .USD)
}
