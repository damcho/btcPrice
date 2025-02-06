//
//  BTCLoadErrorDispatcherAdapterTests.swift
//  BTCUtilityCoreTests
//
//  Created by Damian Modernell on 5/2/25.
//

@testable import BTCUtilityCore
import XCTest

final class BTCLoadErrorDispatcherAdapter {
    let errorDispatcher: BTCPriceErrorDisplayable
    var lastUpdatedBTCDate: Date?
    let loader: () -> Task<Void, Error>
    var timer: Timer?
    let timeout: TimeInterval

    init(
        errorDispatcher: BTCPriceErrorDisplayable,
        loadHandler: @escaping () -> Task<Void, Error>,
        timeout: TimeInterval
    ) {
        self.errorDispatcher = errorDispatcher
        self.loader = loadHandler
        self.timeout = timeout
    }

    func fireErrorDisplayTimerInMainThread() {
        Task { @MainActor in
            timer?.invalidate()
            timer = Timer.scheduledTimer(
                withTimeInterval: timeout,
                repeats: false,
                block: { _ in
                    self.dispatchError()
                }
            )
        }
    }

    private func dispatchError() {
        errorDispatcher.displayBTCLoadError(for: lastUpdatedBTCDate)
    }

    func load() async {
        fireErrorDisplayTimerInMainThread()

        do {
            try await loader().value
        } catch {
            dispatchError()
        }
    }
}

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
}

extension BTCLoadErrorDispatcherAdapterTests {
    func makeSUT(
        loader: @escaping () -> Task<Void, Error>
    )
        -> (BTCLoadErrorDispatcherAdapter, BTCErrorDisplayableSpy)
    {
        let errorDispatcherSpy = BTCErrorDisplayableSpy()
        return (
            BTCLoadErrorDispatcherAdapter(
                errorDispatcher: errorDispatcherSpy,
                loadHandler: loader,
                timeout: 1
            ),
            errorDispatcherSpy
        )
    }
}

final class BTCErrorDisplayableSpy: BTCPriceErrorDisplayable {
    var dispatchedLoadErrorMessages: [ErrorDisplayType] = []
    enum ErrorDisplayType {
        case noTimestamp
        case timeStamp
    }

    func displayBTCLoadError(for timestamp: Date?) {
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
