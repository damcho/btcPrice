//
//  BTCPriceLoadeSchedulerTests.swift
//  BTCPriceLoaderAppTests
//
//  Created by Damian Modernell on 27/1/25.
//

import XCTest

typealias BTCPriceSchedulerInvocationClosure = () -> Void

final class BTCPriceScheduler {
    let repeatTimeInterval: TimeInterval
    private(set)var timer: Timer?
    
    init(repeatTimeInterval: TimeInterval) {
        self.repeatTimeInterval = repeatTimeInterval
    }
    
    func schedule(invocationClosure: @escaping BTCPriceSchedulerInvocationClosure) {
        timer = Timer.scheduledTimer(
            withTimeInterval: repeatTimeInterval,
            repeats: true,
            block: { _ in
                invocationClosure()
            })
    }
}

final class BTCPriceLoadSchedulerTests: XCTestCase {

    func test_repeats_closure_invocation_for_time_interval() {
        let timeInterval = 0.1
        let sut = makeSUT(with: timeInterval)
        var closureInvocationCount = 0
        let expectation = expectation(
            description: "wait for closure invocation fullfilment multiple times"
        )
        expectation.expectedFulfillmentCount = 3
        sut.schedule {
            closureInvocationCount += 1
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}

extension BTCPriceLoadSchedulerTests {
    private func makeSUT(with timeInterval: TimeInterval) -> BTCPriceScheduler {
        BTCPriceScheduler(
            repeatTimeInterval: timeInterval
        )
    }
}
