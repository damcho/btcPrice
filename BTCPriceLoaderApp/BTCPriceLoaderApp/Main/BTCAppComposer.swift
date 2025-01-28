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
    
    static func compose() -> BTCUtilityView {
        let btcErrorViewModel = BTCPriceErrorViewModel()
        let btcPriceViewModel = BTCPriceViewModel()
      
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

struct SuccessfulLoader: BTCPriceLoadable {
    func loadBTCPrice() async throws(RemoteBTCPriceLoaderError) -> BTCPrice {
        BTCPrice(amount: 10.3, currency: .USD)
    }
}
