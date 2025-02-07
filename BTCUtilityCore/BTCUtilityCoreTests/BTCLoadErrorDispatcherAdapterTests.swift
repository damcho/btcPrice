//
//  BTCLoadErrorDispatcherAdapterTests.swift
//  BTCUtilityCoreTests
//
//  Created by Damian Modernell on 5/2/25.
//

@testable import BTCUtilityCore
import XCTest
import TestHelpers

final class BTCLoadErrorDispatcherAdapterTests: XCTestCase {
    func test_displays_error_with_no_timestamp_on_load_error() async {
        let (sut, errorDispatcherSpy) = makeSUT(
            loader: {
                throw anyNSError
            }
        )

        await sut.load()

        XCTAssertEqual(errorDispatcherSpy.dispatchedLoadErrorMessages, [.noTimestamp])
    }

    func test_does_not_dispatch_error_on_btc_loading_completed_immediately() async {
        let (sut, errorDispatcherSpy) = makeSUT(
            loader: {
                self.completeImmediately()
            }
        )

        await sut.load()

        XCTAssertEqual(errorDispatcherSpy.dispatchedLoadErrorMessages, [])
    }

    func test_dispatches_error_on_loading_tiemout() async {
        let errorDispatchTimeout: TimeInterval = 1

        let (sut, errorDispatcherSpy) = makeSUT(
            loader: {
                await self.forLongerThan(errorDispatchTimeout)
            },
            timeout: errorDispatchTimeout
        )

        await sut.load()

        XCTAssertEqual(errorDispatcherSpy.dispatchedLoadErrorMessages, [.noTimestamp])
    }

    func test_stores_last_updated_date_on_btc_loaded_successfully() async {
        let (sut, _) = makeSUT(
            loader: {
                self.completeImmediately()
            }
        )

        XCTAssertNil(sut.lastUpdatedBTCDate)

        await sut.load()

        XCTAssertNotNil(sut.lastUpdatedBTCDate)
    }

    func test_does_not_fire_dispatch_error_timer_on_loader_completion() async {
        let errorDispatchTimeout: TimeInterval = 0.1

        let (sut, errorDispatcherSpy) = makeSUT(
            loader: {
                self.completeImmediately()
            },
            timeout: errorDispatchTimeout
        )

        await sut.load()

        await forLongerThan(errorDispatchTimeout)

        XCTAssertEqual(errorDispatcherSpy.dispatchedLoadErrorMessages, [])
    }

    func test_dispatches_error_in_mainThread() async throws {
        let (sut, errorDispatcherSpy) = makeSUT(
            loader: {
                throw anyNSError
            }
        )

        await sut.load()

        XCTAssertTrue(errorDispatcherSpy.isMainTheread)
    }
}

extension BTCLoadErrorDispatcherAdapterTests {
    func makeSUT(
        loader: @escaping () async throws -> Void,
        timeout: TimeInterval = 1
    )
        -> (BTCLoadErrorDispatcherAdapter, BTCErrorDisplayableSpy)
    {
        let errorDispatcherSpy = BTCErrorDisplayableSpy()
        let sut = BTCLoadErrorDispatcherAdapter(
            errorDispatcher: errorDispatcherSpy,
            loadHandler: loader,
            timeout: timeout
        )

        return (
           sut,
           errorDispatcherSpy
        )
    }

    func forLongerThan(_ timeout: TimeInterval) async {
        sleep(UInt32(timeout + 1))
    }
    
    func completeImmediately() {
        return
    }
}

final class BTCErrorDisplayableSpy: BTCPriceErrorDisplayable {
    var dispatchedLoadErrorMessages: [ErrorDisplayType] = []
    var isMainTheread: Bool = false
    enum ErrorDisplayType {
        case noTimestamp
        case timeStamp
    }

    func displayBTCLoadError(for timestamp: Date?) {
        isMainTheread = Thread.isMainThread
        guard timestamp != nil else {
            dispatchedLoadErrorMessages.append(.noTimestamp)
            return
        }
        dispatchedLoadErrorMessages.append(.timeStamp)
    }
}
