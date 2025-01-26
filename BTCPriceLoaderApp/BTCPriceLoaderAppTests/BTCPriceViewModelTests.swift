//
//  BTCPriceLoaderAppTests.swift
//  BTCPriceLoaderAppTests
//
//  Created by Damian Modernell on 25/1/25.
//

import XCTest
@testable import BTCPriceLoaderApp
@testable import BTCLoader

final class BTCPriceViewModel {
    var btcPrice: BTCPrice?
}

final class BTCPriceViewModelTests: XCTestCase {
    func test_displays_no_btc_on_initial_state() {
        let bTCPriceViewModel = BTCPriceViewModel()
        XCTAssertNil(bTCPriceViewModel.btcPrice)
    }

}
