//
//  BTCPriceErrorViewModel.swift
//  BTCPriceLoaderApp
//
//  Created by Damian Modernell on 26/1/25.
//

import BTCUtilityCore
import Foundation

class BTCPriceErrorViewModel: ObservableObject {
    @Published private(set) var errorLabel: String = ""
    private let dateformatter: DateFormatter

    init(dateFormatter: DateFormatter) {
        self.dateformatter = dateFormatter
    }

    func displayBTCLoadError(for timestamp: Date? = nil) {
        if let atimestamp = timestamp {
            errorLabel =
                "Failed to update value. Displaying last updated value from \(dateformatter.string(from: atimestamp))"
        } else {
            errorLabel = "Failed to load BTC price"
        }
    }

    func hideBTCLoadError() {
        errorLabel = ""
    }
}

// MARK: BTCPriceErrorDisplayable

extension BTCPriceErrorViewModel: BTCPriceErrorDisplayable {}

// MARK: BTCPriceErrorRemovable

extension BTCPriceErrorViewModel: BTCPriceErrorRemovable {}
