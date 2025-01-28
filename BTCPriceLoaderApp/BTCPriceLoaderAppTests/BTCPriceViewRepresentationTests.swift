//
//  BTCPriceViewRepresentationTests.swift
//  BTCPriceLoaderAppTests
//
//  Created by Damian Modernell on 28/1/25.
//

import XCTest
@testable import BTCPriceLoaderApp

final class BTCPriceViewRepresentationTests: XCTestCase {

    func test_adds_currency_symbol_to_price() {
        let representation = BTCPriceViewRepresentation(price: 100.0, color: .gray)
        XCTAssertEqual(representation.stringPriceRepresentation, "$100.00")
    }

    func test_green_btc_price_representation_on_higher_new_value() {
        let initialBTCPrice = BTCPriceViewRepresentation(price: 100.0, color: .gray)
        let higherPriceThanInitialBTCPrice = 101.0
        
        let newBTCPriceFromOldPrice = initialBTCPrice.updateBTCPriceRepresentation(
            for: higherPriceThanInitialBTCPrice
        )
        
        XCTAssertTrue(newBTCPriceFromOldPrice.color == .green)
    }
}
