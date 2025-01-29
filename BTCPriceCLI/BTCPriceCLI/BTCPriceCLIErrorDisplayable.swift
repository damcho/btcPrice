//
//  BTCPriceCLIErrorDisplayable.swift
//  BTCPriceCLI
//
//  Created by Damian Modernell on 29/1/25.
//

import Foundation
import BTCUtilityCore

struct BTCPriceCLIErrorDisplayable: BTCPriceErrorDisplayable {
    let dateformatter: DateFormatter
    
    func displayBTCLoadError(for timestamp: Date?) {
        if let atimestamp = timestamp {
            print("Failed to update value. Displaying last updated value from \(dateformatter.string(from: atimestamp))")
        } else {
            print("Failed to load BTC price")
        }
    }
}
