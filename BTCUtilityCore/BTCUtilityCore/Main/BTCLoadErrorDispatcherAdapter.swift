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

    private func invalidateErrorDisplayTimer() {
        Task { @MainActor in
            timer?.invalidate()
        }
    }

    private func dispatchError() {
        errorDispatcher.displayBTCLoadError(for: lastUpdatedBTCDate)
    }

    func load() async {
        fireErrorDisplayTimerInMainThread()

        do {
            try await loader().value
            lastUpdatedBTCDate = .now
        } catch {
            await MainActor.run {
                dispatchError()
            }
        }

        invalidateErrorDisplayTimer()
    }
}
