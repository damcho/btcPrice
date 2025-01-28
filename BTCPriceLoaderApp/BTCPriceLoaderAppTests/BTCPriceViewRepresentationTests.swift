//
//  BTCPriceViewRepresentationTests.swift
//  BTCPriceLoaderAppTests
//
//  Created by Damian Modernell on 28/1/25.
//

import XCTest
@testable import BTCPriceLoaderApp
import SwiftUICore

final class BTCPriceViewRepresentationTests: XCTestCase {

    func test_adds_currency_symbol_to_price() {
        let representation = BTCPriceViewRepresentation(price: 100.0, color: .gray)
        XCTAssertEqual(representation.stringPriceRepresentation, "$100.00")
    }

    func test_price_representation_color_on_new_btc_value() {
        expect(.green, initialBTCPrice: 100.0, newBTCPrice: 101.0)
        expect(.red, initialBTCPrice: 100.0, newBTCPrice: 99.0)
        expect(.black, initialBTCPrice: 100.0, newBTCPrice: 100.0)
    }
}

extension BTCPriceViewRepresentationTests {
    func expect(_ color: Color, initialBTCPrice: Double, newBTCPrice: Double) {
        let initialBTCPrice = BTCPriceViewRepresentation(
            price: initialBTCPrice,
            color: .gray
        )
        
        let newBTCPriceFromOldPrice = initialBTCPrice.updateBTCPriceRepresentation(
            for: newBTCPrice
        )
        
        XCTAssertTrue(newBTCPriceFromOldPrice.color == color)
    }
}
