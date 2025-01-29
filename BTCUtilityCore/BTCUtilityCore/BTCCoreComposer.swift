//
//  BTCAppComposer.swift
//  BTCPriceLoaderApp
//
//  Created by Damian Modernell on 27/1/25.
//

import Foundation
import BTCLoader
import Networking

public enum BTCCoreComposer {
    static let scheduledBTCLoadInterval = 1.0
    
    static var errorViewModelDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter
    }
    
    static let urlSessionHttpClient = URLSessionHTTPClient(
        session: URLSession(
            configuration: URLSessionHTTPClient.oneSecondTimeoutConfiguration
        )
    )
    
    public static func compose(
        for btcDisplayable: BTCPriceDisplayable,
        errorDisplayable: BTCPriceErrorDisplayable,
        errorRemovable: BTCPriceErrorRemovable? = nil) {
     
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
    }
}
