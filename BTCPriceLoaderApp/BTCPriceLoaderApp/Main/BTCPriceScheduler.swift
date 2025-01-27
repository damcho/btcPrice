//
//  BTCPriceScheduler.swift
//  BTCPriceLoaderApp
//
//  Created by Damian Modernell on 27/1/25.
//

import Foundation

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
