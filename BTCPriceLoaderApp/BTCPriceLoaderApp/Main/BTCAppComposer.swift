//
//  BTCAppComposer.swift
//  BTCPriceLoaderApp
//
//  Created by Damian Modernell on 27/1/25.
//

import BTCUtilityCore
import Foundation

enum BTCAppComposer {
    static func compose() -> BTCUtilityView {
        let btcErrorViewModel = BTCPriceErrorViewModel(
            dateFormatter: BTCCoreComposer.errorDateFormatter
        )
        let btcPriceViewModel = BTCPriceViewModel()

        BTCCoreComposer.compose(
            for: btcPriceViewModel,
            errorDisplayable: btcErrorViewModel,
            errorRemovable: btcErrorViewModel
        )

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
