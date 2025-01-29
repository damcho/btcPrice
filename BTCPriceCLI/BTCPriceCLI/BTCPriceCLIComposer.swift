//
//  BTCPriceCliComposer.swift
//  BTCPriceCLI
//
//  Created by Damian Modernell on 28/1/25.
//

import Foundation
import BTCUtilityCore

struct BTCPriceCLIComposer {
    static var errorViewModelDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter
    }
    
    static func run() -> BTCPriceScheduler {
        BTCCoreComposer.compose(
            for: BTCPriceCLIDisplayable(),
            errorDisplayable: BTCPriceCLIErrorDisplayable(
                dateformatter: errorViewModelDateFormatter
            )
        )
    }
}
