//
//  BTCAppComposer.swift
//  BTCPriceLoaderApp
//
//  Created by Damian Modernell on 27/1/25.
//

import Foundation
import BTCLoader
import Networking

enum BTCAppComposer {
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
    
    static func compose() -> BTCUtilityView {
        let btcErrorViewModel = BTCPriceErrorViewModel(
            dateFormatter: errorViewModelDateFormatter
        )
        let btcPriceViewModel = BTCPriceViewModel()
      
        let btcPriceScheduler = BTCPriceScheduler(
            repeatTimeInterval: BTCAppComposer.scheduledBTCLoadInterval
        )
        let btcLoaderAdapter = BTCLoaderAdapter(
            loader: BTCPriceLoaderUtility.makeLoader(
                with: urlSessionHttpClient
            ),
            btcPriceDisplayable: btcPriceViewModel,
            btcPriceErrorDisplayable: btcErrorViewModel,
            btcPriceErrorRemovable: btcErrorViewModel
        )

        btcPriceScheduler.schedule {
            _ = btcLoaderAdapter.load()
        }
        return BTCUtilityView(
            btcPriceView: BTCPriceView(
                btcPriceViewModel: btcPriceViewModel
            ),
            btcPriceErrorView: BTCPriceErrorView(
                errorViewModel: btcErrorViewModel
            )
        )
    }
}
