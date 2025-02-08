//
//  BTCLoadErrorDispatcherAdapter.swift
//  BTCUtilityCore
//
//  Created by Damian Modernell on 6/2/25.
//

import Foundation

final class BTCLoadErrorDispatcherAdapter {
    let errorDispatcher: BTCPriceErrorDisplayable
    var lastUpdatedBTCDate: Date?
    let loader: () async throws -> Void
    let timeout: Int
    var timer: DispatchSourceTimer?

    init(
        errorDispatcher: BTCPriceErrorDisplayable,
        loadHandler: @escaping () async throws -> Void,
        timeoutInSeconds: Int
    ) {
        self.errorDispatcher = errorDispatcher
        self.loader = loadHandler
        self.timeout = timeoutInSeconds
    }

    func scheduleErrorDIsplayTimerAfterTimeout() {
        let queue = DispatchQueue(label: "display.error.dispatch")
        let atimer = DispatchSource.makeTimerSource(queue: queue)
        atimer.setEventHandler { [weak self] in
            self?.dispatchError()
        }
        atimer.schedule(
            deadline: .now() + DispatchTimeInterval.seconds(timeout),
            repeating: .infinity
        )
        atimer.resume()
        timer = atimer
    }

    private func invalidateErrorDisplayTimer() {
        timer?.cancel()
    }

    private func dispatchError() {
        errorDispatcher.displayBTCLoadError(for: lastUpdatedBTCDate)
    }

    func load() async {
        scheduleErrorDIsplayTimerAfterTimeout()

        do {
            try await loader()
            lastUpdatedBTCDate = .now
        } catch {
            dispatchError()
        }

        invalidateErrorDisplayTimer()
    }
}
