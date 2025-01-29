//
//  BTCPriceCliComposer.swift
//  BTCPriceCLI
//
//  Created by Damian Modernell on 28/1/25.
//

import Foundation
import BTCUtilityCore

struct BTCPriceCLIComposer {
    static func run() -> BTCPriceScheduler {
        BTCCoreComposer.compose(
            for: BTCPriceCLIDisplayable(),
            errorDisplayable: BTCPriceCLIErrorDisplayable(
                dateformatter: BTCCoreComposer.errorDateFormatter
            )
        )
    }
}
