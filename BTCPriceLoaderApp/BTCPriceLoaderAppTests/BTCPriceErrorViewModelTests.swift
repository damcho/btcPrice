//
//  BTCPriceErrorViewModelTests.swift
//  BTCPriceLoaderAppTests
//
//  Created by Damian Modernell on 26/1/25.
//

import XCTest

final class BTCPriceErrorViewModel {
    var errorLabel: String = "Failed to load BTC price"
}

final class BTCPriceErrorViewModelTests: XCTestCase {

    func test_displays_error_with_no_btc_price_on_initialization() {
        let btcErrorViewModel = BTCPriceErrorViewModel()
        XCTAssertEqual(btcErrorViewModel.errorLabel, "Failed to load BTC price")
    }

}
