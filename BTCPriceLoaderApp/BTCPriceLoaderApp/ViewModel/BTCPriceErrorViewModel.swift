//
//  BTCPriceErrorViewModel.swift
//  BTCPriceLoaderApp
//
//  Created by Damian Modernell on 26/1/25.
//

import Foundation

final class BTCPriceErrorViewModel {
    private(set)var errorLabel: String = ""
    var lastUpdatedBTCPriceDate: Date?
    private let dateformatter: DateFormatter
    
    init(dateFormatter: DateFormatter = DateFormatter()) {
        self.dateformatter = dateFormatter
    }
    
    func displayBTCLoadError() {
        if let alastUpdatedBTCPriceDate = lastUpdatedBTCPriceDate {
            errorLabel = "Failed to update value. Displaying last updated value from \(dateformatter.string(from: alastUpdatedBTCPriceDate))"
        } else {
            errorLabel = "Failed to load BTC price"
        }
    }
    
    func hideBTCLoadError(at date: Date) {
        lastUpdatedBTCPriceDate = date
        errorLabel = ""
    }
}
