//
//  CoinbaseBTCLoaderMapperTests.swift
//  BTCLoaderTests
//
//  Created by Damian Modernell on 24/1/25.
//

import XCTest
@testable import BTCLoader
import TestHelpers

final class CoinbaseBTCLoaderMapperTests: XCTestCase, BTCMapperSpecs {
    func test_throws_on_non_200_http_response() throws {
        XCTAssertThrowsError(
            try CoinbaseBTCLoaderMapper.map(http: (non200HTTPResponse, anyData))
        )
    }
    
    func test_throws_on_200_response_and_empty_data() throws {
        let emptyData = Data()
        XCTAssertThrowsError(
            try CoinbaseBTCLoaderMapper.map(http: (validHTTPResponse, emptyData))
        )
    }
    
    func test_maps_btc_price_successfully() throws {
        let expectedBTCPrice = anyCoinbaseBTCPrice
        
        let decodedBTCprice = try CoinbaseBTCLoaderMapper.map(
            http: (validHTTPResponse, expectedBTCPrice.encoded)
        )
        
        XCTAssertEqual(decodedBTCprice, expectedBTCPrice.decoded)
    }
    
    func test_throws_on_decoding_error() throws {
        XCTAssertThrowsError(
            try CoinbaseBTCLoaderMapper.map(
                http: (validHTTPResponse, anyInvalidEncodedBTCPrice.encoded)
            )
        )
    }
}
