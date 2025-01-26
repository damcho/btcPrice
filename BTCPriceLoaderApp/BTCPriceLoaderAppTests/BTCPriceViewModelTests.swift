//
//  BTCPriceLoaderAppTests.swift
//  BTCPriceLoaderAppTests
//
//  Created by Damian Modernell on 25/1/25.
//

import XCTest
@testable import BTCPriceLoaderApp
@testable import BTCLoader

struct BTCPriceViewRepresentation {
    let price: String
    let color: UIColor
}

final class BTCPriceViewModel {
    var btcPriceLabel: String = ""
    var btcPrice: BTCPriceViewRepresentation = .init(price: "", color: .black) {
        didSet {
            btcPriceLabel = "BTC/USD: \(btcPrice.price)"
        }
    }
}

final class BTCPriceViewModelTests: XCTestCase {
    func test_displays_empty_string_on_initialization() {
        let bTCPriceViewModel = BTCPriceViewModel()
        XCTAssertEqual(bTCPriceViewModel.btcPrice.color, .black)
        XCTAssertEqual(bTCPriceViewModel.btcPrice.price, "")
    }
}
