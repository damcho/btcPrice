//
//  BTCPriceViewModelTests.swift
//  BTCPriceLoaderAppTests
//
//  Created by Damian Modernell on 25/1/25.
//

@testable import BTCLoader
@testable import BTCPriceLoaderApp
import XCTest

final class BTCPriceViewModelTests: XCTestCase {
    func test_displays_empty_string_on_initialization() {
        let bTCPriceViewModel = BTCPriceViewModel()
        XCTAssertEqual(bTCPriceViewModel.btcPrice.color, .black)
        XCTAssertEqual(bTCPriceViewModel.btcPriceLabel, "")
    }

    func test_displays_btc_price_on_new_btc_price_set() {
        let bTCPriceViewModel = BTCPriceViewModel()
        bTCPriceViewModel.btcPrice = .init(price: 123, color: .red)

        XCTAssertEqual(
            bTCPriceViewModel.btcPriceLabel,
            BTCPriceLabelFormat.btc.value(for: bTCPriceViewModel.btcPrice)
        )
    }
}
