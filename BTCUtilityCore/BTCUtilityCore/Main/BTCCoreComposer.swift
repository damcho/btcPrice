//
//  BTCCoreComposer.swift
//  BTCPriceLoaderApp
//
//  Created by Damian Modernell on 27/1/25.
//

import BTCLoader
import Foundation
import Networking

public enum BTCCoreComposer {
    static let scheduledBTCLoadInterval = 1.0
    static let errorDispatchTimeout = 1

    public static var errorDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter
    }

    static let urlSessionHttpClient = URLSessionHTTPClient(
        session: .shared
    )

    /**
     Schedules BTC price loading every second.
     BTCPriceDisplayable,BTCPriceErrorDisplayable and BTCPriceErrorRemovable are not guaranteed to be invoked in the main thread, it is up to the implementer to dispatch to the main thread if needed for UI purposes
     */
    @discardableResult
    public static func compose(
        for btcDisplayable: BTCPriceDisplayable,
        errorDisplayable: BTCPriceErrorDisplayable,
        errorRemovable: BTCPriceErrorRemovable? = nil
    )
        -> BTCPriceScheduler
    {
        let btcPriceScheduler = BTCPriceScheduler(
            repeatTimeInterval: BTCCoreComposer.scheduledBTCLoadInterval
        )
        let btcLoaderAdapter = BTCLoaderAdapter(
            loader: RemoteBTCPriceLoaderUtility.makeLoader(
                with: urlSessionHttpClient
            ),
            btcPriceDisplayable: btcDisplayable,
            btcPriceErrorRemovable: errorRemovable
        )
        let btcPriceErrorDispatcher = BTCLoadErrorDispatcherAdapter(
            errorDispatcher: errorDisplayable,
            loadHandler: btcLoaderAdapter.load,
            timeoutInSeconds: errorDispatchTimeout
        )

        btcPriceScheduler.schedule {
            Task {
                await btcPriceErrorDispatcher.load()
            }
        }
        return btcPriceScheduler
    }
}
