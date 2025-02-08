//
//  BTCPriceMainThreadDispatcherTests.swift
//  BTCPriceLoaderAppTests
//
//  Created by Damian Modernell on 8/2/25.
//

@testable import BTCPriceLoaderApp
import BTCUtilityCore
import XCTest

struct BTCPriceMainThreadDispatcher {
    let decoratee: BTCPriceDisplayable
}

// MARK: BTCPriceDisplayable

extension BTCPriceMainThreadDispatcher: BTCPriceDisplayable {
    func display(_ btcPrice: BTCPrice) {
        Task { @MainActor in
            decoratee.display(btcPrice)
        }
    }
}

final class BTCPriceMainThreadDispatcherTests: XCTestCase {
    func test_dispatches_btc_price_on_main_thread() async {
        let expectation = expectation(description: "wait for decoratee to be called")
        let (sut, spy) = makeSUT(dispatchExpectation: expectation)

        sut.display(anyBTCPrice)

        await fulfillment(of: [expectation], timeout: 1)
        XCTAssertTrue(spy.dispatchedOnMainThread)
    }
}

extension BTCPriceMainThreadDispatcherTests {
    func makeSUT(dispatchExpectation: XCTestExpectation) -> (BTCPriceMainThreadDispatcher, BTCPriceDisplayableSpy) {
        let spy = BTCPriceDisplayableSpy(
            expectation: dispatchExpectation
        )
        let sut = BTCPriceMainThreadDispatcher(
            decoratee: spy
        )
        return (
            sut,
            spy
        )
    }
}

var anyBTCPrice: BTCPrice {
    .init(amount: 10.0, currency: .USD)
}

final class BTCPriceDisplayableSpy: BTCPriceDisplayable {
    var dispatchedOnMainThread: Bool = false
    let expectation: XCTestExpectation

    init(expectation: XCTestExpectation) {
        self.expectation = expectation
    }

    func display(_ btcPrice: BTCPrice) {
        dispatchedOnMainThread = Thread.isMainThread
        expectation.fulfill()
    }
}
