//
//  BTCPriceLoaderAdapterTests.swift
//  BTCPriceLoaderAppTests
//
//  Created by Damian Modernell on 26/1/25.
//

import BTCLoader
@testable import BTCUtilityCore
import Networking
import XCTest

final class BTCPriceLoaderAdapterTests: XCTestCase {
    func test_displays_btc_price_on_successful_load() async throws {
        let (sut, btcPriceDisplayableSpy, _) = makeSUT(
            btcloadableStub: .success(anyBTCPrice)
        )

        try await sut.load()

        XCTAssertEqual(
            btcPriceDisplayableSpy.displayableMessages,
            [.hideError, .success(anyBTCPrice)]
        )
    }

    func test_hides_error_on_successful_btc_price_load() async throws {
        let (sut, btcPriceDisplayableSpy, _) = makeSUT(
            btcloadableStub: .success(anyBTCPrice)
        )
        XCTAssertEqual(btcPriceDisplayableSpy.displayableMessages, [])

        try await sut.load()

        XCTAssertEqual(
            btcPriceDisplayableSpy.displayableMessages,
            [.hideError, .success(anyBTCPrice)]
        )
    }

    func test_dispatches_on_main_thread_on_btc_price_load() async throws {
        try await expecttoDispatchOnMainThread(
            forLoaderResult: .success(
                anyBTCPrice
            )
        )
    }

    func test_throws_on_btc_price_load_failure() async throws {
        let (sut, _, _) = makeSUT(
            btcloadableStub: .failure(.connectivity)
        )

        await AsyncXCTAssertThrowsError(
            try await sut.load()
        )
    }
}

extension BTCPriceLoaderAdapterTests {
    private func makeSUT(
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
        return (loaderAdapter, btcDisplayableSpy, btcLoadableStub)
    }

    private func expecttoDispatchOnMainThread(
        forLoaderResult: Result<BTCPrice, BTCPriceLoaderError>,
        file: StaticString = #file,
        line: UInt = #line
    ) async throws {
        let (sut, btcDisplayableSpy, _) = makeSUT(
            btcloadableStub: forLoaderResult
        )

        try await sut.load()

        XCTAssertTrue(btcDisplayableSpy.isMainThread, file: file, line: line)
    }
}

class BTCPriceDisplayableSpy: BTCPriceDisplayable, BTCPriceErrorRemovable {
    var displayableMessages: [BTCDisplayable] = []
    var isMainThread = false
    var didDisplayError = false
    var displayable: BTCPrice?
    func display(_ price: BTCPrice) {
        isMainThread = Thread.isMainThread
        displayableMessages.append(.success(price))
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

extension XCTest {
    func AsyncXCTAssertThrowsError(
        _ expression: @autoclosure () async throws -> some Sendable,
        _ message: @autoclosure () -> String = "This call should throw an error.",
        file: StaticString = #filePath,
        line: UInt = #line,
        _ errorHandler: (_ error: Error) -> Void = { _ in }
    ) async {
        do {
            _ = try await expression()
            XCTFail(message(), file: file, line: line)
        } catch {
            errorHandler(error)
        }
    }
}
