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
        let (sut, errorDispatcherSpy) = await makeSUT(
            loader: {
                throw anyNSError
            }
        )

        await sut.load()

        XCTAssertEqual(errorDispatcherSpy.dispatchedLoadErrorMessages, [.noTimestamp])
    }

    func test_does_not_dispatch_error_on_btc_loading_completed_immediately() async {
        let (sut, errorDispatcherSpy) = await makeSUT(
            loader: {
                self.completeImmediately()
            }
        )

        await sut.load()

        XCTAssertEqual(errorDispatcherSpy.dispatchedLoadErrorMessages, [])
    }

    func test_dispatches_error_on_loading_tiemout() async {
        let errorDispatchTimeout = 1

        let (sut, errorDispatcherSpy) = await makeSUT(
            loader: {
                await self.forLongerThan(errorDispatchTimeout)
            },
            timeout: errorDispatchTimeout
        )

        await sut.load()

        XCTAssertEqual(errorDispatcherSpy.dispatchedLoadErrorMessages, [.noTimestamp])
    }

    func test_stores_last_updated_date_on_btc_loaded_successfully() async {
        let (sut, _) = await makeSUT(
            loader: {
                self.completeImmediately()
            }
        )

        XCTAssertNil(sut.lastUpdatedBTCDate)

        await sut.load()

        XCTAssertNotNil(sut.lastUpdatedBTCDate)
    }

    func test_invalidates_timer_on_loader_completion_before_timeout() async {
        let errorDispatchTimeout = 1

        let (sut, errorDispatcherSpy) = await makeSUT(
            loader: {
                self.completeImmediately()
            },
            timeout: errorDispatchTimeout
        )

        await sut.load()

        await forLongerThan(errorDispatchTimeout)

        XCTAssertEqual(errorDispatcherSpy.dispatchedLoadErrorMessages, [])
    }
}

extension BTCLoadErrorDispatcherAdapterTests {
    @MainActor func makeSUT(
        loader: @escaping () async throws -> Void,
        timeout: Int = 1,
        file: StaticString = #filePath,
        line: UInt = #line
    )
        -> (BTCLoadErrorDispatcherAdapter, BTCErrorDisplayableSpy)
    {
        var sut: BTCLoadErrorDispatcherAdapter?
        var errorDispatcherSpy: BTCErrorDisplayableSpy?
        
        autoreleasepool {
            errorDispatcherSpy = BTCErrorDisplayableSpy()
            sut = BTCLoadErrorDispatcherAdapter(
                errorDispatcher: errorDispatcherSpy!,
                loadHandler: loader,
                timeoutInSeconds: timeout
            )
        }
      
        trackForMemoryLeaks(sut!, file: file, line: line)
        trackForMemoryLeaks(errorDispatcherSpy!, file: file, line: line)

        return (
           sut!,
           errorDispatcherSpy!
        )
    }

    func forLongerThan(_ timeout: Int) async {
        sleep(UInt32(timeout + 1))
    }
    
    func completeImmediately() {
        return
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
