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

}
