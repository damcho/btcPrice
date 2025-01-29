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

    public static var errorDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter
    }

    static let urlSessionHttpClient = URLSessionHTTPClient(
        session: URLSession(
            configuration: URLSessionHTTPClient.oneSecondTimeoutConfiguration
        )
    )

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
            loader: BTCPriceLoaderUtility.makeLoader(
                with: urlSessionHttpClient
            ),
            btcPriceDisplayable: btcDisplayable,
            btcPriceErrorDisplayable: errorDisplayable,
            btcPriceErrorRemovable: errorRemovable
        )

        btcPriceScheduler.schedule {
            _ = btcLoaderAdapter.load()
        }
        return btcPriceScheduler
    }
}
