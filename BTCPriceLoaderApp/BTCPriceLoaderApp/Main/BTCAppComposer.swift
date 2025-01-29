//
//  BTCAppComposer.swift
//  BTCPriceLoaderApp
//
//  Created by Damian Modernell on 27/1/25.
//

import Foundation
import BTCLoader
import Networking
import BTCUtilityCore

enum BTCAppComposer {    
    static var errorViewModelDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter
    }
    
    static func compose() -> BTCUtilityView {
        let btcErrorViewModel = BTCPriceErrorViewModel(
            dateFormatter: errorViewModelDateFormatter
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
