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

    init(
        errorDispatcher: BTCPriceErrorDisplayable
    ) {
        self.errorDispatcher = errorDispatcher
    }

    func load() {
        errorDispatcher.displayBTCLoadError(for: lastUpdatedBTCDate)
    }
}

final class BTCLoadErrorDispatcherAdapterTests: XCTestCase {
    func test_displays_error_with_no_timestamp_on_load_error() {
        let (sut, errorDispatcherSpy) = makeSUT()

        sut.load()

        XCTAssertEqual(errorDispatcherSpy.didDispatchLoadErrorMessages.count, 1)
    }
}

extension BTCLoadErrorDispatcherAdapterTests {
    func makeSUT()
        -> (BTCLoadErrorDispatcherAdapter, BTCErrorDisplayableSpy)
    {
        let errorDispatcherSpy = BTCErrorDisplayableSpy()
        return (
            BTCLoadErrorDispatcherAdapter(
                errorDispatcher: errorDispatcherSpy
            ),
            errorDispatcherSpy
        )
    }
}

final class BTCErrorDisplayableSpy: BTCPriceErrorDisplayable {
    var didDispatchLoadErrorMessages: [Date?] = []

    func displayBTCLoadError(for timestamp: Date?) {
        didDispatchLoadErrorMessages.append(timestamp)
    }
}

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}
