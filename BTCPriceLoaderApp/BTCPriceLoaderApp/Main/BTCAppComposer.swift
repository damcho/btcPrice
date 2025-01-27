//
//  BTCAppComposer.swift
//  BTCPriceLoaderApp
//
//  Created by Damian Modernell on 27/1/25.
//

import Foundation
import BTCLoader

enum BTCAppComposer {
    static let scheduledBTCLoadInterval = 1.0
    
    static func compose() -> BTCPriceView {
        let btcErrorViewModel = BTCPriceErrorViewModel()
        let btcPriceViewModel = BTCPriceViewModel()
        let btcErrorView = BTCPriceErrorView(
            errorViewModel: btcErrorViewModel
        )
        let btcPriceScheduler = BTCPriceScheduler(
            repeatTimeInterval: BTCAppComposer.scheduledBTCLoadInterval
        )
        let btcLoaderAdapter = BTCLoaderAdapter(
            loader: SuccessfulLoader(),
            btcPriceViewModel: btcPriceViewModel,
            btcPriceErrorViewModel: btcErrorViewModel
        )

        btcPriceScheduler.schedule {
            _ = btcLoaderAdapter.load()
        }
        return BTCPriceView(
            btcPriceViewModel: btcPriceViewModel,
            errorView: btcErrorView
        )
    }
}

struct SuccessfulLoader: BTCPriceLoadable {
    func loadBTCPrice() async throws(RemoteBTCPriceLoaderError) -> BTCPrice {
        BTCPrice(amount: 10.3, currency: .USD)
    }
}
