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

    init(
        errorDispatcher: BTCPriceErrorDisplayable,
        loadHandler: @escaping () -> Task<Void, Error>
    ) {
        self.errorDispatcher = errorDispatcher
        self.loader = loadHandler
    }

    func load() async {
        do {
            try await loader().value
        } catch {
            errorDispatcher.displayBTCLoadError(for: lastUpdatedBTCDate)
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
                loadHandler: loader
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
