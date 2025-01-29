//
//  BTCPriceLoadSchedulerTests.swift
//  BTCPriceLoaderAppTests
//
//  Created by Damian Modernell on 27/1/25.
//

@testable import BTCUtilityCore
import XCTest

final class BTCPriceLoadSchedulerTests: XCTestCase {
    func test_repeats_closure_invocation_for_time_interval() {
        let expectedTimeInterval = 0.1
        let sut = makeSUT(with: expectedTimeInterval)
        let expectation = expectation(
            description: "wait for closure invocation fullfilment multiple times"
        )
        expectation.expectedFulfillmentCount = 3
        sut.schedule {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(expectedTimeInterval, sut.scheduledTime)
        sut.stop()
    }
}

extension BTCPriceScheduler {
    func stop() {
        timer?.invalidate()
    }

    var scheduledTime: TimeInterval {
        timer!.timeInterval
    }
}

extension BTCPriceLoadSchedulerTests {
    private func makeSUT(with timeInterval: TimeInterval) -> BTCPriceScheduler {
        BTCPriceScheduler(
            repeatTimeInterval: timeInterval
        )
    }
}
