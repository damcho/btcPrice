//
//  BTCPriceErrorViewModel.swift
//  BTCPriceLoaderApp
//
//  Created by Damian Modernell on 26/1/25.
//

import BTCUtilityCore
import Foundation

enum BTCPriceErrorFormat {
    case noTimesamp
    case timestamp(String)

    var value: String {
        switch self {
        case .noTimesamp:
            "Failed to load BTC price"
        case let .timestamp(date):
            "Failed to update value. Displaying last updated value from \(date)"
        }
    }
}

class BTCPriceErrorViewModel: ObservableObject {
    @Published private(set) var errorLabel: String = ""
    private let dateformatter: DateFormatter

    init(dateFormatter: DateFormatter) {
        self.dateformatter = dateFormatter
    }

    func displayBTCLoadError(for timestamp: Date? = nil) {
        if let atimestamp = timestamp {
            errorLabel = BTCPriceErrorFormat.timestamp(
                dateformatter.string(from: atimestamp)
            ).value

        } else {
            errorLabel = BTCPriceErrorFormat.noTimesamp.value
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
