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
    var timer: Timer?
    let timeout: TimeInterval

    init(
        errorDispatcher: BTCPriceErrorDisplayable,
        loadHandler: @escaping () async throws -> Void,
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
            try await loader()
            lastUpdatedBTCDate = .now
        } catch {
            await MainActor.run {
                dispatchError()
            }
        }

        invalidateErrorDisplayTimer()
    }
}
