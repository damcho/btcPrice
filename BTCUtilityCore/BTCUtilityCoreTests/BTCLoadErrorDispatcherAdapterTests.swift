//
//  BTCLoadErrorDispatcherAdapterTests.swift
//  BTCUtilityCoreTests
//
//  Created by Damian Modernell on 5/2/25.
//

@testable import BTCUtilityCore
import XCTest

final class BTCLoadErrorDispatcherAdapterTests: XCTestCase {
    func test_displays_error_with_no_timestamp_on_load_error() async {
        let (sut, errorDispatcherSpy) = makeSUT(
            loader: {
                Task { throw anyNSError() }
            }
        )

        await sut.load()

        XCTAssertEqual(errorDispatcherSpy.dispatchedLoadErrorMessages, [.noTimestamp])
    }

    func test_does_not_dispatch_error_on_btc_loading_completed_immediately() async {
        let (sut, errorDispatcherSpy) = makeSUT(
            loader: {
                Task {}
            }
        )

        await sut.load()

        XCTAssertEqual(errorDispatcherSpy.dispatchedLoadErrorMessages, [])
    }

    func test_dispatches_error_on_loading_tiemout() async {
        let (sut, errorDispatcherSpy) = makeSUT(
            loader: {
                Task {
                    sleep(2)
                }
            }
        )

        await sut.load()

        XCTAssertEqual(errorDispatcherSpy.dispatchedLoadErrorMessages, [.noTimestamp])
    }

    func test_stores_last_updated_date_on_btc_loaded_successfully() async {
        let (sut, _) = makeSUT(
            loader: {
                Task {
                    sleep(0)
                }
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
                Task {
                    sleep(0)
                }
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
                Task {
                    throw anyNSError()
                }
            }
        )

        await sut.load()

        XCTAssertTrue(errorDispatcherSpy.isMainTheread)
    }
}

extension BTCLoadErrorDispatcherAdapterTests {
    func makeSUT(
        loader: @escaping () -> Task<Void, Error>,
        timeout: TimeInterval = 1
    )
        -> (BTCLoadErrorDispatcherAdapter, BTCErrorDisplayableSpy)
    {
        let errorDispatcherSpy = BTCErrorDisplayableSpy()
        return (
            BTCLoadErrorDispatcherAdapter(
                errorDispatcher: errorDispatcherSpy,
                loadHandler: loader,
                timeout: timeout
            ),
            errorDispatcherSpy
        )
    }

    func forLongerThan(_ timeout: TimeInterval) async {
        sleep(UInt32(timeout + 0.1))
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

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}
